package com.edfapg.flutter.sdk.methodhandlers

import android.content.Context
import com.edfapg.sdk.core.EdfaPgSdk
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class SetFailureAnimationMethodHandler(
    private val context: Context,
    private val call: MethodCall,
    private val result: MethodChannel.Result
) {

    fun handle() {
        (call.arguments as? List<*>)?.let {
            with(it) {
                (get(0) as? String)?.let { url ->
                    EdfaPgSdk.setFailureAnimation(url)
                }
            }
        }
    }

}