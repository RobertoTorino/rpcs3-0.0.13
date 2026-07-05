# Building 0.0.13 for Tekken Revolution Reborn

Only Windows is supported for building this special repository

## Setup your environment

### Windows 10 or later

* CMake (add to PATH)
* Python (add to PATH)
* Qt 6.11.1, MSVC x64 kit
* Visual Studio 2022 with the C++ desktop workload
* Vulkan SDK (See "Install the SDK" [here](https://vulkan.lunarg.com/doc/sdk/latest/windows/getting_started.html))
* LLVM 11 source tree under `llvm/`, or a prebuilt LLVM 11 install exposed via `LLVM_DIR`

This repository has been updated for Qt6, so Qt6-only install can be used directly.

For a one-step build, use [build_windows_release.bat](build_windows_release.bat). 
It configures a Release x64 build, builds the `rpcs3` target, and opens the build folder when it finishes. 
The script locates Visual Studio 2022 with `vswhere`/`VsDevCmd.bat`, then uses either the local `llvm/` source tree or `LLVM_DIR` if you already have a prebuilt LLVM 11 setup.

The build flow now runs CMake through `tools/build_windows_release.ps1`, which executes configure/build in isolated child processes, writes logs to `build-windows-release/build-logs`, and automatically retries when a step is interrupted (for example by an accidental Ctrl+C in an attached terminal).

For a fast command-line entry point with optional clean and deploy flags, use `tools/quick_build_rpcs3.ps1`:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\quick_build_rpcs3.ps1 -Clean -DeployQt
```

### Quick binary build (Windows)

Use these exact commands from a PowerShell terminal:

1. Go to the repository root:

```powershell
cd C:\development\rpcs3-0.0.13
```

2. Run the one-shot build script:

```powershell
.\build_windows_release.bat
```

3. Get the resulting binary:
  - Main executable: `build-windows-release\bin\rpcs3.exe`
  - Build logs: `build-windows-release\build-logs\`

If you prefer the PowerShell entry point:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\quick_build_rpcs3.ps1 -Clean
```

If LLVM auto-detection does not match your machine layout, pass `-LLVMDir` explicitly:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\quick_build_rpcs3.ps1 -Clean -LLVMDir "C:\path\to\lib\cmake\llvm"
```

### LLVM 11 setup

RPCS3 0.0.13 expects LLVM 11, not a newer LLVM release.

You have two valid Windows setups:

1. Source tree in `llvm/`
	- Put a Windows-compatible LLVM 11 source checkout at `c:\development\rpcs3-0.0.13\llvm`.
	- The folder must contain `CMakeLists.txt`.
	- The build script will configure LLVM from source with the RPCS3 build.

2. Prebuilt LLVM 11 install
	- Build or install LLVM 11 separately.
	- Point `LLVM_DIR` to the directory that contains `LLVMConfig.cmake`.
	- In a typical install, that is `...\lib\cmake\llvm`.

If you need to build LLVM 11 yourself, start from a clean LLVM 11 source tree and configure it with the Visual Studio 2022 generator, x64, and a minimal feature set. Run it with this script:

```
"C:\development\rpcs3-0.0.13\build_llvm11.ps1"
```

After that, set `LLVM_DIR` to the generated `lib\cmake\llvm` directory from the LLVM build or install tree.


#### Building the projects

Open `rpcs3.sln`. The recommended build configuration is `Release - LLVM` for all purposes.

You may want to download the precompiled [LLVM libs](https://github.com/RPCS3/llvm-mirror/releases/download/custom-build-win/llvmlibs_mt.7z) and extract them to the root rpcs3 folder (which contains `rpcs3.sln`), as well as download and extract the [additional libs](https://github.com/RPCS3/glslang/releases/download/custom-build-win/glslanglibs_mt.7z) to `lib\%CONFIGURATION%-x64\` to speed up compilation time (unoptimised/debug libs are currently not available precompiled).

If you're not using the precompiled libs, build the projects in *__BUILD_BEFORE* folder: right-click on every project > *Build*.

`Build > Build Solution`

#### Helpers
To bypass the helper script and see exactly what CMake is complaining about, use this command:  

```
cmake -S C:\development\rpcs3-0.0.13 -B C:\development\rpcs3-0.0.13\build-windows-release -G "Visual Studio 18 2026" -A x64 -Thost=x64 "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" "-DLLVM_DIR=C:\development\rpcs3-0.0.13\llvm11-build\lib\cmake\llvm" "-DQt6_DIR=C:\Qt\6.11.1\msvc2022_64\lib\cmake\Qt6"
```

Remove folder:  
```
Remove-Item -Path "C:\development\rpcs3-0.0.13\build-windows-release" -Recurse -Force -ErrorAction SilentlyContinue
```

Remove not found cached files:  
```
git rm --cached 3rdparty/WhateverNameItComplainedAbout
```

Regarding this warning MSB8028: 
```
The intermediate directory (LLVMDlltoolDriver.dir\Release\) contains files shared from another project (LLVMDlltoolDriver.vcxproj).
This can lead to incorrect clean and rebuild behavior.
```
Then if you ever need to rebuild:           
if the build fails later for a different reason, or if you need to reconfigure it, don't just run the build command again.          
Instead, delete the entire `C:\development\rpcs3-0.0.13\llvm11-build` folder and let CMake recreate it from scratch.         

For new build run below command from workspace root:	

Configure:
cmd /d /c configure_rpcs3.bat

Build the binary:
cmd /d /c build_rpcs3_binary.bat

Clean the build tree if needed:
cmd /d /c clean_rpcs3_build.bat