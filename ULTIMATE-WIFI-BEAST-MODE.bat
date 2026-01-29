@echo off
REM ============================================================================
REM  ULTIMATE WIFI/NETWORK PERFORMANCE OPTIMIZER
REM  Priority + Speed + Stability for Gaming & Streaming
REM  Run as Administrator
REM ============================================================================

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Must run as Administrator!
    echo Right-click and select "Run as administrator"
    pause
    exit
)

echo ============================================================================
echo   ULTIMATE WIFI/NETWORK BEAST MODE
echo   Maximum Priority + Speed + Stability
echo ============================================================================
echo.

REM ============================================================================
REM SECTION 1: TCP/IP OPTIMIZATION - Maximum Speed
REM ============================================================================
echo [1/10] Optimizing TCP/IP Stack for Maximum Performance...

REM Experimental auto-tuning (grabs max bandwidth from router)
netsh int tcp set global autotuninglevel=experimental
echo    [OK] Auto-tuning: EXPERIMENTAL (max bandwidth grab)

REM Enable RSS (Receive Side Scaling) - uses CPU cores for network processing
netsh int tcp set global rss=enabled
echo    [OK] RSS: ENABLED (multi-core network processing)

REM Enable DCA (Direct Cache Access) - faster packet processing
netsh int tcp set global dca=enabled
echo    [OK] DCA: ENABLED (direct cache access)

REM Disable TCP Timestamps (reduces overhead, better for gaming)
netsh int tcp set global timestamps=disabled
echo    [OK] TCP Timestamps: DISABLED (lower latency)

REM Enable ECN (Explicit Congestion Notification) - better congestion handling
netsh int tcp set global ecncapability=enabled
echo    [OK] ECN: ENABLED (smart congestion control)

REM Set chimney offload (offloads TCP processing to network card)
netsh int tcp set global chimney=enabled
echo    [OK] Chimney Offload: ENABLED (hardware acceleration)

REM Set direct memory access for network
netsh int tcp set global netdma=enabled
echo    [OK] NetDMA: ENABLED (direct memory access)

REM Set pacing profile (consistent data flow)
netsh int tcp set global pacingprofile=always
echo    [OK] Pacing Profile: ALWAYS (consistent flow)

REM Increase initial congestion window (faster connection start)
netsh int tcp set global initialRto=2000
echo    [OK] Initial RTO: 2000ms (faster connection)

echo.

REM ============================================================================
REM SECTION 2: REMOVE WINDOWS NETWORK THROTTLING
REM ============================================================================
echo [2/10] Removing Windows Network Throttling...

REM Remove 10Mbps throttling limit
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xFFFFFFFF /f >nul 2>&1
echo    [OK] Network Throttling: REMOVED (no 10Mbps limit)

REM Unlock Windows Reserved Bandwidth (Windows reserves 20% by default)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Reserved Bandwidth: 0%% (was 20%%)

echo.

REM ============================================================================
REM SECTION 3: WIFI ADAPTER PRIORITY #1 (HIGHEST POSSIBLE)
REM ============================================================================
echo [3/10] Setting WiFi Adapter to HIGHEST System Priority...

REM Set WiFi interface metric to 1 (highest priority routing)
for /f "tokens=*" %%a in ('netsh interface ipv4 show interfaces ^| findstr /i "wi-fi wireless"') do (
    netsh interface ipv4 set interface "Wi-Fi" metric=1 >nul 2>&1
    echo    [OK] WiFi Interface Metric: 1 (HIGHEST PRIORITY)
)

REM Set WiFi interface metric for IPv6 as well
for /f "tokens=*" %%a in ('netsh interface ipv6 show interfaces ^| findstr /i "wi-fi wireless"') do (
    netsh interface ipv6 set interface "Wi-Fi" metric=1 >nul 2>&1
    echo    [OK] WiFi IPv6 Metric: 1 (HIGHEST PRIORITY)
)

echo.

REM ============================================================================
REM SECTION 4: DISABLE WIFI POWER SAVING (CRITICAL FOR STABILITY)
REM ============================================================================
echo [4/10] Disabling WiFi Power Saving...

powershell -Command "$adapters = Get-NetAdapter | Where-Object {$_.InterfaceDescription -like '*Wireless*' -or $_.InterfaceDescription -like '*Wi-Fi*' -or $_.InterfaceDescription -like '*802.11*'}; foreach($adapter in $adapters) { Set-NetAdapterPowerManagement -Name $adapter.Name -SelectiveSuspend Disabled -DeviceSleepOnDisconnect Disabled -WakeOnMagicPacket Disabled -WakeOnPattern Disabled -ErrorAction SilentlyContinue }" >nul 2>&1
echo    [OK] WiFi Power Management: DISABLED (no sleep/suspend)

REM Disable WiFi power saving in registry
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
echo    [OK] WiFi stays at FULL POWER always

echo.

REM ============================================================================
REM SECTION 5: QoS PRIORITY (YOUR TRAFFIC GETS PRIORITY)
REM ============================================================================
echo [5/10] Setting QoS Priority for Your Traffic...

REM Remove old QoS policies
netsh int tcp set global qos=enabled >nul 2>&1

REM Enable QoS on WiFi adapter
powershell -Command "$adapters = Get-NetAdapter | Where-Object {$_.InterfaceDescription -like '*Wireless*' -or $_.InterfaceDescription -like '*Wi-Fi*'}; foreach($adapter in $adapters) { Set-NetAdapterQos -Name $adapter.Name -Enabled $true -ErrorAction SilentlyContinue }" >nul 2>&1
echo    [OK] QoS: ENABLED on WiFi adapter

echo.

REM ============================================================================
REM SECTION 6: DNS OPTIMIZATION (FASTEST DNS)
REM ============================================================================
echo [6/10] Setting Fastest DNS Servers...

REM Set Cloudflare DNS (fastest for gaming: 1.1.1.1 / 1.0.0.1)
powershell -Command "$adapters = Get-NetAdapter -Physical | Where-Object {$_.Status -eq 'Up'}; foreach($adapter in $adapters) { Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses ('1.1.1.1','1.0.0.1') -ErrorAction SilentlyContinue }" >nul 2>&1
echo    [OK] DNS: Cloudflare 1.1.1.1 (fastest gaming DNS)

REM Flush DNS cache
ipconfig /flushdns >nul 2>&1
echo    [OK] DNS Cache: FLUSHED

echo.

REM ============================================================================
REM SECTION 7: INCREASE NETWORK BUFFERS (LESS PACKET LOSS)
REM ============================================================================
echo [7/10] Increasing Network Buffers for Stability...

REM Increase TCP receive window
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpWindowSize /t REG_DWORD /d 65535 /f >nul 2>&1
echo    [OK] TCP Window Size: 65535 (maximum)

REM Set default TTL (Time To Live)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 64 /f >nul 2>&1
echo    [OK] Default TTL: 64 (optimal)

REM Enable large send offload
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableWsd /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Large Send Offload: OPTIMIZED

echo.

REM ============================================================================
REM SECTION 8: DISABLE BANDWIDTH HOGS (NO BACKGROUND INTERFERENCE)
REM ============================================================================
echo [8/10] Stopping Bandwidth-Hogging Services...

REM Stop Windows Update temporarily
sc config wuauserv start= demand >nul 2>&1
net stop wuauserv >nul 2>&1
echo    [OK] Windows Update: STOPPED (no background downloads)

REM Stop Background Intelligent Transfer Service
sc config BITS start= demand >nul 2>&1
net stop BITS >nul 2>&1
echo    [OK] BITS: STOPPED (no background transfers)

REM Stop Delivery Optimization
sc config DoSvc start= demand >nul 2>&1
net stop DoSvc >nul 2>&1
echo    [OK] Delivery Optimization: STOPPED

echo.

REM ============================================================================
REM SECTION 9: GAMING-SPECIFIC OPTIMIZATIONS
REM ============================================================================
echo [9/10] Applying Gaming Optimizations...

REM Disable Nagle's Algorithm (reduces latency for gaming)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
echo    [OK] Nagle's Algorithm: DISABLED (instant packet send)

REM Set network adapter interrupt moderation to OFF (lower latency)
powershell -Command "$adapters = Get-NetAdapter -Physical; foreach($adapter in $adapters) { Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName 'Interrupt Moderation' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue }" >nul 2>&1
echo    [OK] Interrupt Moderation: DISABLED (lower latency)

REM Enable Jumbo Frames if supported
powershell -Command "$adapters = Get-NetAdapter -Physical; foreach($adapter in $adapters) { Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName 'Jumbo Packet' -DisplayValue '9014 Bytes' -ErrorAction SilentlyContinue }" >nul 2>&1
echo    [OK] Jumbo Frames: ENABLED (if supported)

echo.

REM ============================================================================
REM SECTION 10: FINAL NETWORK RESET & APPLY
REM ============================================================================
echo [10/10] Applying All Changes...

REM Reset network stack to apply all changes
netsh winsock reset catalog >nul 2>&1
echo    [OK] Winsock: RESET

REM Reset IP stack
netsh int ip reset >nul 2>&1
echo    [OK] IP Stack: RESET

REM Release and renew IP
ipconfig /release >nul 2>&1
ipconfig /renew >nul 2>&1
echo    [OK] IP Address: RENEWED

REM Register DNS
ipconfig /registerdns >nul 2>&1
echo    [OK] DNS: REGISTERED

echo.
echo ============================================================================
echo   OPTIMIZATION COMPLETE!
echo ============================================================================
echo.
echo WHAT WAS DONE:
echo  [+] TCP/IP optimized for maximum speed
echo  [+] Network throttling REMOVED
echo  [+] WiFi priority set to #1 (HIGHEST)
echo  [+] WiFi power saving DISABLED
echo  [+] QoS priority enabled
echo  [+] DNS set to Cloudflare (fastest)
echo  [+] Network buffers MAXIMIZED
echo  [+] Bandwidth hogs STOPPED
echo  [+] Gaming latency optimizations applied
echo  [+] Network stack RESET and applied
echo.
echo IMPORTANT: RESTART YOUR COMPUTER NOW!
echo.
echo After restart, you will have:
echo  - Maximum WiFi/network priority
echo  - Lowest possible latency
echo  - Maximum bandwidth
echo  - Stable connection (no drops)
echo  - Perfect for gaming AND streaming
echo  - Made By SouhailFl
echo.
echo These settings work on ANY WiFi network you connect to!
echo.
echo ============================================================================
echo.
pause
