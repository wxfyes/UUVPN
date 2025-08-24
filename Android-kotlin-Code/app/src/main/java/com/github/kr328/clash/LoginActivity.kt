package com.github.kr328.clash

import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.text.InputType
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.github.kr328.clash.common.compat.isAllowForceDarkCompat
import com.github.kr328.clash.common.compat.isLightNavigationBarCompat
import com.github.kr328.clash.common.compat.isLightStatusBarsCompat
import com.github.kr328.clash.common.compat.isSystemBarsTranslucentCompat
import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.databinding.ActivityLoginBinding
import com.github.kr328.clash.design.databinding.ActivityProfileBinding
import com.github.kr328.clash.design.ui.DayNight
import com.github.kr328.clash.design.ui.ToastDuration
import com.github.kr328.clash.design.util.layoutInflater
import com.github.kr328.clash.design.util.resolveThemedBoolean
import com.github.kr328.clash.design.util.resolveThemedColor
import com.github.kr328.clash.design.util.root
import com.github.kr328.clash.network.ApiClient
import com.github.kr328.clash.network.ApiClientConfig
import com.github.kr328.clash.network.ApiService
import com.github.kr328.clash.network.ConfigResponse
import com.github.kr328.clash.network.LoginRequest
import com.github.kr328.clash.network.LoginResponse
import com.github.kr328.clash.network.safeApiCall
import com.github.kr328.clash.network.safeApiRequestCall
import com.github.kr328.clash.utity.LoadingDialog
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONException
import org.json.JSONObject

class LoginActivity : AppCompatActivity() {

    private lateinit var apiService: ApiService

    private var dayNight: DayNight = DayNight.Day
    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        // 禁用返回键
        // 不调用 super.onBackPressed()
    }


    private var isPasswordVisible = false


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

          val binding = ActivityLoginBinding
            .inflate(this.layoutInflater, this.root, false)

        setContentView(binding.root)

        applyDayNight()

        PreferenceManager.init(this)

        binding.togglePasswordVisibility.setOnClickListener {

            isPasswordVisible = !isPasswordVisible

            if (isPasswordVisible) {
                // 显示明文密码
                binding.loginPasswordEditText.inputType = InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD
                binding.togglePasswordVisibility.setImageResource(R.drawable.visibility_24px) // 更改图标为显示状态
            } else {
                // 显示星号密码
                binding.loginPasswordEditText.inputType = InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_PASSWORD
                binding.togglePasswordVisibility.setImageResource(R.drawable.visibility_off_24px) // 更改图标为隐藏状态
            }
            // 将光标移动到文本的末尾
            binding.loginPasswordEditText.setSelection(binding.loginPasswordEditText.text.length)

        }
        binding.loginLoginButton.setOnClickListener {
            val email = binding.loginEmailEditText.text.toString()
            val password = binding.loginPasswordEditText.text.toString()
            val isAgreementChecked = binding.loginAgreementCheckBox.isChecked


            if (email.isEmpty() || password.isEmpty()) {
                Toast.makeText(this, "请输入邮箱和密码", Toast.LENGTH_SHORT).show()
            } else if (!isAgreementChecked) {
                Toast.makeText(this, "请同意隐私政策和用户协议", Toast.LENGTH_SHORT).show()
            } else {

                // Hide the keyboard
                val inputMethodManager = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                val currentFocusView = currentFocus
                if (currentFocusView != null) {
                    inputMethodManager.hideSoftInputFromWindow(currentFocusView.windowToken, 0)
                }
                CoroutineScope(Dispatchers.Main).launch {
                    performLogin(email, password)
                }
            }
        }

        binding.loginForgotPassword.setOnClickListener {
            // Navigate to Forgot Password screen or show dialog
        }

        binding.loginRegister.setOnClickListener {
            // Navigate to Register screen
            //startActivity(RegisterActivity::class::intent)
           // startActivity(RegisterActivity::class::intent)
            val intent = Intent(this@LoginActivity, RegisterActivity::class.java)
            startActivity(intent)
           // finish()  // It

        }


        apiService = ApiClientConfig.retrofit.create(ApiService::class.java)

        //获取 Config 数据
        getconfig()
    }

    private fun getconfig(){

        LoadingDialog.show(this, "正在初始化...")
        CoroutineScope(Dispatchers.IO).launch {

            safeApiCall {apiService.getConfig()}.let {
                if (it != null) {
                    if (it.code == 1 ) {
                        withContext(Dispatchers.Main) {
                            LoadingDialog.hide()
                        }
                        PreferenceManager.saveConfigToPreferences( it)
                        //重新初始化 ApiClint
                    }
                }else{
                    getconfig()
                }
            }
        }
    }

    /**
     *  withContext(Dispatchers.Main) {
     *             if (response.isSuccessful) {
     *                 val userData = response.body()
     *                 // 更新 UI
     *             } else {
     *                 Toast.makeText(this@MainActivity, "Failed to fetch user data", Toast.LENGTH_SHORT).show()
     *             }
     *         }
     * */

    private fun applyDayNight(config: Configuration = resources.configuration) {
        // val dayNight =  theme.applyStyle(R.style.AppThemeLight, true) //默认白天模式

        /*
        val dayNight =   queryDayNight(config)
        when (dayNight) {
            DayNight.Night -> theme.applyStyle(R.style.AppThemeDark, true)
            DayNight.Day -> theme.applyStyle(R.style.AppThemeLight, true)
        }*/

        window.isAllowForceDarkCompat = false
        window.isSystemBarsTranslucentCompat = true

        window.statusBarColor = resolveThemedColor(android.R.attr.statusBarColor)
        window.navigationBarColor = resolveThemedColor(android.R.attr.navigationBarColor)

        if (Build.VERSION.SDK_INT >= 23) {
            window.isLightStatusBarsCompat = resolveThemedBoolean(android.R.attr.windowLightStatusBar)
        }

        if (Build.VERSION.SDK_INT >= 27) {
            window.isLightNavigationBarCompat = resolveThemedBoolean(android.R.attr.windowLightNavigationBar)
        }

        this.dayNight =  DayNight.Night //dayNight
    }

    private suspend fun performLogin(email: String, password: String) {
        // Show the loading indicator with a custom message
        LoadingDialog.show(this, "正在登录...")

        val apiServiceApp = ApiClient.retrofit.create(ApiService::class.java)

        //获取 Config 数据
        withContext(Dispatchers.IO) {

            safeApiRequestCall {
                apiServiceApp.loginUser(LoginRequest(email,password))}.let {
                withContext(Dispatchers.Main) {
                    LoadingDialog.hide()
                }
                

                
                if (it != null && it.isSuccessful) {
                    val response: LoginResponse? = it.body()
                    
                    // 检查响应数据
                    if (response?.data != null) {
                        
                        PreferenceManager.loginemail = email
                        PreferenceManager.loginToken = response.data?.token ?: ""
                        PreferenceManager.loginauthData = response.data?.auth_data ?: ""
                        PreferenceManager.isLoginin = true

                        withContext(Dispatchers.Main) {
                            val intent = Intent(this@LoginActivity, MainActivity::class.java)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                            startActivity(intent)
                            finish()
                        }
                    } else {
                        // 显示数据为空的情况
                        withContext(Dispatchers.Main) {
                            Toast.makeText(this@LoginActivity, "登录失败：服务器返回数据为空", Toast.LENGTH_LONG).show()
                        }
                    }
                } else {
                    // Handle error response, even if it's 422
                    try {
                        val errorResponse = it?.errorBody()?.string() ?: ""
                        val errorJson = JSONObject(errorResponse)
                        val message = errorJson.optString("message")
                        // Process the error message or show it to the user
                        if (!message.isNullOrEmpty()) {
                            withContext(Dispatchers.Main) {
                                Toast.makeText(this@LoginActivity, "登录失败：${message}", Toast.LENGTH_LONG).show()
                            }
                        } else {
                            withContext(Dispatchers.Main) {
                                Toast.makeText(this@LoginActivity, "登录失败：网络请求失败", Toast.LENGTH_LONG).show()
                            }
                        }
                    } catch (e: JSONException) {
                        // Handle JSON parsing error
                        withContext(Dispatchers.Main) {
                            Toast.makeText(this@LoginActivity, "登录失败：响应格式错误", Toast.LENGTH_LONG).show()
                        }
                    }
                }
            }
        }
    }
}
