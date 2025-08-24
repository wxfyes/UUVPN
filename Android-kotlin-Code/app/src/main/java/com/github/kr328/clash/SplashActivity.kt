package com.github.kr328.clash

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.databinding.ActivityLoginBinding
import com.github.kr328.clash.design.databinding.ActivitySplashBinding
import com.github.kr328.clash.design.util.root
import com.github.kr328.clash.network.ApiService


class SplashActivity : AppCompatActivity() {



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding = ActivitySplashBinding
            .inflate(this.layoutInflater, this.root, false)

        setContentView(binding.root)
        PreferenceManager.init(this)
        
        // 添加调试日志
        println("SplashActivity onCreate - 检查登录状态:")
        println("isLoginin: ${PreferenceManager.isLoginin}")
        println("loginemail: ${PreferenceManager.loginemail}")
        println("loginauthData: ${PreferenceManager.loginauthData}")

        Handler(Looper.getMainLooper()).postDelayed({
            // Hide the loading indicator
            if (PreferenceManager.isLoginin && PreferenceManager.loginauthData.isNotEmpty()) {
                // 用户已登录，直接跳转到主界面
                println("用户已登录，跳转到MainActivity")
                startActivity(MainActivity::class.intent)
            } else {
                // 用户未登录，跳转到登录界面
                println("用户未登录，跳转到LoginActivity")
                startActivity(LoginActivity::class.intent)
            }
            finish()

        }, 1000) // Simulating a network delay


    }
}
