FROM jlesage/baseimage-gui:ubuntu-22.04-v4
LABEL maintainer="Hezekiah Ho, aka funcman <hyq1986@gmail.com>"

ENV APP_NAME="115pc" \
    APP_VERSION="37.2.3" \
    USER_ID=0 \
    GROUP_ID=0 \
    ENABLE_CJK_FONT=1 \
    DISPLAY_WIDTH="1920" \
    DISPLAY_HEIGHT="1080" \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

# 使用 HTTP 源，避免证书缺失
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list

# 现在更新并安装基础工具（包含 ca-certificates）
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    locales \
    && rm -rf /var/lib/apt/lists/*

# 生成中文 locale
RUN locale-gen zh_CN.UTF-8

# 安装图形依赖（此时已有证书，也可以继续使用 HTTP，但无所谓）
RUN apt-get update && apt-get install -y --no-install-recommends \
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

# 下载安装 115 客户端
RUN curl -fL -o /tmp/115Life_${APP_VERSION}.deb \
    https://down.115.com/client/115pc/lin/115Life_${APP_VERSION}.deb && \
    dpkg -i /tmp/115Life_${APP_VERSION}.deb || true && \
    apt-get update && apt-get install -f -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/115Life_${APP_VERSION}.deb /var/cache/apt/archives/*

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

CMD ["/startapp.sh"]
