package me.weishu.kernelsu.ui.screen.home

import android.content.Context
import androidx.compose.runtime.Immutable
import androidx.core.content.pm.PackageInfoCompat

@Immutable
data class ManagerVersion(
    val versionName: String,
    val versionCode: Long
)

@Immutable
data class SystemInfo(
    val kernelVersion: String,
    val managerVersion: String,
    val buildNumber: String,
    val fingerprint: String,
    val selinuxStatus: String,
    val seccompStatus: Int,
    /** "None" when no Zygisk module reports a name (matches legacy home screen). */
    val zygiskName: String,
    val zygiskVersion: String,
)

fun getManagerVersion(context: Context): ManagerVersion {
    val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)!!
    val versionCode = PackageInfoCompat.getLongVersionCode(packageInfo)
    return ManagerVersion(
        versionName = packageInfo.versionName!!,
        versionCode = versionCode
    )
}
