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

# 使用 HTTP 源（避免证书问题）
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list

# 第一步：安装 base-files，补充缺失的系统文件
RUN apt-get update && apt-get install -y --no-install-recommends \
    base-files \
    && rm -rf /var/lib/apt/lists/*

# 第二步：安装基础工具（ca-certificates 和 curl 等）
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    locales \
    && rm -rf /var/lib/apt/lists/*

# 生成中文 locale
RUN locale-gen zh_CN.UTF-8

# 下载并安装 115 客户端（此处 apt-get install -f 可能仍会拉入 systemd，但此时 /etc/passwd 已存在，即使 systemd 被安装也能正常配置）
RUN curl -fL -o /tmp/115Life_${APP_VERSION}.deb \
    https://down.115.com/client/115pc/lin/115Life_${APP_VERSION}.deb && \
    dpkg -i /tmp/115Life_${APP_VERSION}.deb || true && \
    apt-get update && apt-get install -f -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/115Life_${APP_VERSION}.deb /var/cache/apt/archives/*

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

CMD ["/startapp.sh"]
