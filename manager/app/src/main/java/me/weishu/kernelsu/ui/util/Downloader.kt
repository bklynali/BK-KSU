package me.weishu.kernelsu.ui.util

import android.net.Uri
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.onEach
import me.weishu.kernelsu.ksuApp
import me.weishu.kernelsu.ui.util.module.LatestVersionInfo
import okhttp3.Request

/**
 * @author weishu
 * @date 2023/6/22.
 */
suspend fun download(
    url: String,
    fileName: String,
    onDownloaded: (Uri) -> Unit = {},
    onDownloading: () -> Unit = {},
    onProgress: (Int) -> Unit = {}
) {
    onDownloading()

    val downloadId = DownloadManager.enqueue(
        context = ksuApp,
        url = url,
        fileName = fileName,
        onCompleted = onDownloaded,
    )

    DownloadManager.downloads
        .onEach { map -> map[downloadId]?.let { onProgress(it.progress) } }
        .first { map ->
            val status = map[downloadId]?.status
            status == DownloadManager.Status.COMPLETED ||
                status == DownloadManager.Status.FAILED
        }
}

fun checkNewVersion(): LatestVersionInfo {
    if (!isNetworkAvailable(ksuApp)) return LatestVersionInfo()
    val url = "https://api.github.com/repos/bklynali/BK-KSU/releases/latest"
    // default null value if failed
    val defaultValue = LatestVersionInfo()
    runCatching {
        ksuApp.okhttpClient.newCall(Request.Builder().url(url).build()).execute()
            .use { response ->
                if (!response.isSuccessful) {
                    return defaultValue
                }
                val body = response.body.string()
                val json = org.json.JSONObject(body)
                val changelog = json.optString("body")

                val assets = json.getJSONArray("assets")
                for (i in 0 until assets.length()) {
                    val asset = assets.getJSONObject(i)
                    val name = asset.getString("name")
                    if (!name.endsWith(".apk")) {
                        continue
                    }

                    // Match filenames like:
                    // BK-KSU_v1.0.1_32221-release.apk
                    // BK-KSU_v1.0.1_32221.apk
                    // Extract:
                    //  - versionName: v1.0.1
                    //  - versionCode: 32221 (numeric part after the last underscore)
                    val nameRegex = Regex("BK-KSU_(v?\\d+(?:\\.\\d+){1,2})")
                    val nameMatch = nameRegex.find(name) ?: continue
                    val versionName = nameMatch.groupValues.getOrNull(1) ?: continue

                    val codeRegex = Regex("BK-KSU_.*?_(\\d+)")
                    val codeMatch = codeRegex.find(name) ?: continue
                    val versionCode = codeMatch.groupValues.getOrNull(1)?.toIntOrNull() ?: continue
                    val downloadUrl = asset.getString("browser_download_url")

                    return LatestVersionInfo(
                        versionCode = versionCode,
                        versionName = versionName,
                        downloadUrl = downloadUrl,
                        changelog = changelog,
                    )
                }

            }
    }
    return defaultValue
}
