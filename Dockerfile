FROM jlesage/baseimage-gui:ubuntu-18.04
LABEL maintainer="Hezekiah Ho, aka funcman <hyq1986@gmail.com>"

ENV APP_NAME="115pc" \
    APP_VERSION="37.2.3" \
    USER_ID=0 \
    GROUP_ID=0 \
    ENABLE_CJK_FONT=1 \
    DISPLAY_WIDTH="1920" \
    DISPLAY_HEIGHT="1080" \
    APT_SOURCE_HOST="mirrors.ustc.edu.cn" \
    DEBIAN_FRONTEND=noninteractive

# 替换 apt 源（包括 security 源）
RUN sed -i "s/archive.ubuntu.com/${APT_SOURCE_HOST}/g" /etc/apt/sources.list && \
    sed -i "s/security.ubuntu.com/${APT_SOURCE_HOST}/g" /etc/apt/sources.list

# 一次性安装所需依赖和工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    locales \
    libgtk-3-0 \
    libx11-xcb1 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxcb-xfixes0 \
    libxcb-shape0 \
    && rm -rf /var/lib/apt/lists/*

# 生成中文 locale
RUN locale-gen zh_CN.UTF-8

# 下载并安装 115 客户端，自动修复依赖
RUN curl -fL -o /tmp/115Life_${APP_VERSION}.deb \
    https://down.115.com/client/115pc/lin/115Life_${APP_VERSION}.deb && \
    dpkg -i /tmp/115Life_${APP_VERSION}.deb || true && \
    apt-get update && apt-get install -f -y && \
    rm -rf /var/lib/apt/lists/* /tmp/115Life_${APP_VERSION}.deb

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

CMD ["/startapp.sh"]
