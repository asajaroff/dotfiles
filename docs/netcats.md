# Redis
{ echo -e '*1\r\n$4\r\nPING\r\n'; sleep 1; } | netcat redis.host.com 6379

# Graylog
echo -n '{ "version": "1.1", "host": "example.org", "short_message": "A short message", "level": 5, "_some_info": "foo" }' | nc -w1 -u ${HOST} 12202


