# Network

## TCP/UDP sockets

```bash
# /𝗱𝗲𝘃/𝘁𝗰𝗽/<𝗵𝗼𝘀𝘁>/<𝗽𝗼𝗿𝘁> opens a TCP socket with no extra packages.

# Google request
{ echo -e "GET / HTTP/1.0\r\nHost: www.google.com\r\n\r" >&3; cat <&3 ; } 3<> /dev/tcp/www.google.com/80

# 𝗥𝗲𝗱𝗶𝘀 𝘁𝗲𝘀𝘁 (𝗻𝗼 𝗽𝗮𝘀𝘀𝘄𝗼𝗿𝗱):
𝘦𝘹𝘦𝘤 3<>/𝘥𝘦𝘷/𝘵𝘤𝘱/𝘳𝘦𝘥𝘪𝘴-𝘩𝘰𝘴𝘵/6379 && 𝘦𝘤𝘩𝘰 -𝘦 "𝘗𝘐𝘕𝘎\𝘳\𝘯" >&3 && 𝘤𝘢𝘵 <&3
```