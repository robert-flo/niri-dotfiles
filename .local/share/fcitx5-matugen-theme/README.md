# fcitx5-matugen-theme

这是 Fcitx5 Classic UI 的 Matugen 模板集合。

本仓库不是可执行程序，没有构建步骤，也没有安装或卸载脚本；它提供可以直接交给 Matugen 使用的完整 Fcitx5 主题模板。

Matugen 会从图片或单一颜色生成 Material You 配色，并将配色写入完整的 `theme.conf` 和四个 SVG 文件。背景 SVG 会在生成阶段通过 `scripts/render-panel.sh` 转为 `panel.png`，保留阴影，避免 Fcitx5 5.1.22+ 在每次输入时重复执行 SVG 模糊滤镜。配置可通过 `post_hook` 在文件生成完成后自动重新加载 Fcitx5 Classic UI，无需退出或重新启动 Fcitx5。

## 依赖

* Fcitx5
* Matugen
* `rsvg-convert`（Arch：`librsvg`），用于生成带阴影的 PNG 背景
* `busctl`，用于通过用户 D-Bus 热重载 Fcitx5 Classic UI

`busctl` 通常由 systemd 软件包提供。

本 README 按 Matugen `4.1.0` 验证。Arch Linux 官方仓库提供了 `extra/matugen`：

```sh
sudo pacman -S matugen
```

## 克隆仓库

```sh
git clone https://github.com/StatIndet/fcitx5-matugen-theme.git
cd fcitx5-matugen-theme
```

## 创建输出目录

在注册模板前，先创建 Fcitx5 主题目录。

### Bash 或 Zsh

```sh
mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/fcitx5/themes/Matugen"
```

### Fish

```fish
set data_home "$HOME/.local/share"
set -q XDG_DATA_HOME; and set data_home "$XDG_DATA_HOME"

mkdir -p "$data_home/fcitx5/themes/Matugen"
```

默认主题目录为：

```text
~/.local/share/fcitx5/themes/Matugen/
```

`mkdir -p` 会在目录不存在时创建目录；如果目录已经存在，也不会报错。

本仓库不会主动创建或删除用户目录，目录管理属于用户环境和 Matugen 配置的一部分。

## 注册模板

将下面的内容添加到：

```text
~/.config/matugen/config.toml
```

将每个 `input_path` 中的：

```text
/absolute/path/to/fcitx5-matugen-theme
```

替换为仓库的实际绝对路径。可以在仓库根目录运行以下命令查看：

```sh
pwd
```

配置示例：

```toml
[config]

[templates.fcitx5_theme]
input_path = "/absolute/path/to/fcitx5-matugen-theme/templates/theme.conf"
output_path = "~/.local/share/fcitx5/themes/Matugen/theme.conf"
index = 10

[templates.fcitx5_panel]
input_path = "/absolute/path/to/fcitx5-matugen-theme/templates/panel.svg"
output_path = "~/.local/share/fcitx5/themes/Matugen/panel.svg"
index = 20
post_hook = "bash \"/absolute/path/to/fcitx5-matugen-theme/scripts/render-panel.sh\" \"$HOME/.local/share/fcitx5/themes/Matugen/panel.svg\" \"$HOME/.local/share/fcitx5/themes/Matugen/panel.png\""

[templates.fcitx5_highlight]
input_path = "/absolute/path/to/fcitx5-matugen-theme/templates/highlight.svg"
output_path = "~/.local/share/fcitx5/themes/Matugen/highlight.svg"
index = 30

[templates.fcitx5_radio]
input_path = "/absolute/path/to/fcitx5-matugen-theme/templates/radio.svg"
output_path = "~/.local/share/fcitx5/themes/Matugen/radio.svg"
index = 40

[templates.fcitx5_arrow]
input_path = "/absolute/path/to/fcitx5-matugen-theme/templates/arrow.svg"
output_path = "~/.local/share/fcitx5/themes/Matugen/arrow.svg"
index = 50
post_hook = "busctl --user call org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1 ReloadAddonConfig s classicui"
```

一个 Matugen 命令会处理所有已注册的模板，不需要分别运行五条生成命令。

`index` 用于明确模板的处理顺序。背景转换钩子配置在 `fcitx5_panel` 上；热重载钩子只配置在最后生成的 `fcitx5_arrow` 模板上，以确保以下六个主题文件全部写入完成后，再通知 Fcitx5 重新加载 Classic UI：

```text
theme.conf
panel.svg
panel.png
highlight.svg
radio.svg
arrow.svg
```

`matugen image` 或 `matugen color` 只负责提供配色来源；模板的输入路径、输出路径、执行顺序和重载钩子均由 `config.toml` 决定。

如果使用了非默认的 `XDG_DATA_HOME`，请将五个 `output_path` 中的 `~/.local/share` 和背景转换 hook 中的 `$HOME/.local/share` 替换为实际目录。不要在 Matugen 的 TOML 路径中直接使用 Shell 变量表达式。

Matugen 会在目标文件已存在时重新生成并覆盖这些文件。

## 从图片生成

将 `/path/to/wallpaper.png` 替换成自己的图片路径：

```sh
matugen image /path/to/wallpaper.png -m dark --source-color-index 0
```

生成亮色主题：

```sh
matugen image /path/to/wallpaper.png -m light --source-color-index 0
```

`-m dark` 生成暗色配色，`-m light` 生成亮色配色。

`--source-color-index 0` 会选择图片中最主要的源色，避免多色图片触发交互式选择。希望手动选择源色时，可以省略该参数。

## 从颜色生成

Matugen 也可以从单一 HEX 颜色生成完整的 Material You 配色：

```sh
matugen color hex "#6750A4" -m dark
```

生成亮色主题：

```sh
matugen color hex "#6750A4" -m light
```

当前 Matugen CLI 也提供 `rgb` 和 `hsl` 子命令。可以通过以下命令查看对应帮助：

```sh
matugen color rgb --help
matugen color hsl --help
```

## 检查输出

生成成功后，目标目录应包含：

```text
theme.conf
panel.svg
panel.png
highlight.svg
radio.svg
arrow.svg
```

### Bash 或 Zsh

```sh
find "${XDG_DATA_HOME:-$HOME/.local/share}/fcitx5/themes/Matugen" \
    -maxdepth 1 -type f -print
```

### Fish

```fish
set data_home "$HOME/.local/share"
set -q XDG_DATA_HOME; and set data_home "$XDG_DATA_HOME"

find "$data_home/fcitx5/themes/Matugen" \
    -maxdepth 1 -type f -print
```

## 首次应用到 Fcitx5

首次生成主题后，运行：

```sh
fcitx5-configtool
```

然后在 Classic UI 的主题设置中选择：

```text
Matugen
```

本仓库不会自动修改用户的 Fcitx5 配置，因此首次选择主题仍需手动完成。

主题选择为 `Matugen` 后，再次运行 `matugen image` 或 `matugen color` 时，配置中的 `post_hook` 会自动通过 D-Bus 重新加载 Classic UI，新的配色应立即生效。

## 自动热重载

主题生成完成后，Matugen 会自动执行：

```sh
busctl --user call \
    org.fcitx.Fcitx5 \
    /controller \
    org.fcitx.Fcitx.Controller1 \
    ReloadAddonConfig \
    s classicui
```

该命令只重新加载 Classic UI 插件配置，不会终止或重新启动 Fcitx5 进程。

自动热重载需要满足以下条件：

* Fcitx5 正在当前用户会话中运行。
* Classic UI 插件已经启用。
* Classic UI 当前选择的主题是 `Matugen`。
* `busctl` 可以通过当前用户的 `PATH` 找到。
* 当前会话的用户 D-Bus 正常工作。

## 手动重新加载与排错

如果主题文件已经生成，但界面没有更新，可以手动执行：

```sh
busctl --user call \
    org.fcitx.Fcitx5 \
    /controller \
    org.fcitx.Fcitx.Controller1 \
    ReloadAddonConfig \
    s classicui
```

也可以检查 Fcitx5 的 D-Bus 服务是否存在：

```sh
busctl --user status org.fcitx.Fcitx5
```

检查 Classic UI 是否是当前界面插件：

```sh
busctl --user call \
    org.fcitx.Fcitx5 \
    /controller \
    org.fcitx.Fcitx.Controller1 \
    CurrentUI
```

正常情况下，不需要通过杀死并重新启动 Fcitx5 的方式应用主题。

## 更新主题

更换图片或颜色后，只需再次运行对应命令：

```sh
matugen image /path/to/wallpaper.png -m dark --source-color-index 0
```

或者：

```sh
matugen color hex "#6750A4" -m dark
```

Matugen 会依次处理五个模板，并额外生成 `panel.png`，并在最后一个文件生成完成后自动重新加载 Fcitx5 Classic UI。

不需要重新克隆仓库，也不需要手动重新启动 Fcitx5。

## 致谢

[fcitx5-mellow-themes](https://github.com/sanweiya/fcitx5-mellow-themes/tree/main?tab=readme-ov-file)




## Clavis Advanced 托管

托管五个模板时保留上述顺序。将 `render-panel.sh` 一并复制到稳定的用户配置目录，并将 `fcitx5_panel` 的 hook 指向该副本。`fcitx5_arrow` 仍负责最后热重载。Advanced 不使用 `index` 字段，按注册顺序生成。源仓库更新后需同步托管模板和脚本。

`theme.conf` 的输入面板和菜单均使用 `panel.png`；`panel.svg` 保留为生成中间文件。转换失败不会覆盖上一次成功的 PNG。SVG 的实际尺寸为 30×30，切片边距应保证中心宽高大于零。
