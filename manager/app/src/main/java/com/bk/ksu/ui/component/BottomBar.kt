package com.bk.ksu.ui.component

import androidx.annotation.StringRes
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.CloudDownload
import androidx.compose.material.icons.rounded.Cottage
import androidx.compose.material.icons.rounded.Extension
import androidx.compose.material.icons.rounded.Security
import androidx.compose.material.icons.rounded.Settings
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import dev.chrisbanes.haze.HazeState
import dev.chrisbanes.haze.HazeStyle
import dev.chrisbanes.haze.hazeEffect
import com.bk.ksu.Natives
import com.bk.ksu.R
import com.bk.ksu.ui.LocalHandlePageChange
import com.bk.ksu.ui.LocalPagerState
import com.bk.ksu.ui.util.rootAvailable
import top.yukonga.miuix.kmp.basic.NavigationBar
import top.yukonga.miuix.kmp.basic.NavigationItem


@Composable
fun BottomBar(
    hazeState: HazeState,
    hazeStyle: HazeStyle
) {
    val isManager = Natives.isManager
    val fullFeatured = isManager && !Natives.requireNewKernel() && rootAvailable()

    val page = LocalPagerState.current.targetPage
    val handlePageChange = LocalHandlePageChange.current

    if (!fullFeatured) return

    val item = BottomBarDestination.entries.map { destination ->
        NavigationItem(
            label = stringResource(destination.label),
            icon = destination.icon,
        )
    }

    NavigationBar(
        modifier = Modifier
            .hazeEffect(hazeState) {
                style = hazeStyle
                blurRadius = 30.dp
                noiseFactor = 0f
            },
        color = Color.Transparent,
        items = item,
        selected = page,
        onClick = handlePageChange
    )
}

enum class BottomBarDestination(
    @get:StringRes val label: Int,
    val icon: ImageVector,
) {
    ModuleRepo(R.string.module_repos, Icons.Rounded.CloudDownload),
    Module(R.string.module, Icons.Rounded.Extension),
    Home(R.string.home, Icons.Rounded.Cottage),
    SuperUser(R.string.superuser, Icons.Rounded.Security),
    Setting(R.string.settings, Icons.Rounded.Settings)
}
