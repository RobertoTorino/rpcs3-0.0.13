# Define paths to make it easier to update later
$SourceDir = "C:\development\rpcs3-0.0.13\llvm-project-11\llvm"
$BuildDir  = "C:\development\rpcs3-0.0.13\llvm11-build"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Configuring LLVM with CMake..."           -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Configure step (Arguments quoted to prevent PowerShell parsing errors)
cmake -S $SourceDir -B $BuildDir -G "Visual Studio 18 2026" -A x64 -Thost=x64 `
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" `
    "-DLLVM_TARGETS_TO_BUILD=X86" `
    "-DLLVM_BUILD_RUNTIME=OFF" `
    "-DLLVM_BUILD_TOOLS=OFF" `
    "-DLLVM_INCLUDE_BENCHMARKS=OFF" `
    "-DLLVM_INCLUDE_DOCS=OFF" `
    "-DLLVM_INCLUDE_EXAMPLES=OFF" `
    "-DLLVM_INCLUDE_TESTS=OFF" `
    "-DLLVM_INCLUDE_TOOLS=OFF" `
    "-DLLVM_INCLUDE_UTILS=OFF"

# Check if configuration was successful
if ($LASTEXITCODE -ne 0) {
    Write-Error "CMake configuration failed. Check the errors above."
    exit $LASTEXITCODE
}

Write-Host "`n=========================================" -ForegroundColor Cyan
Write-Host " Building LLVM Release Target..."            -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

# Default ALL_BUILD target
cmake --build $BuildDir --config Release

# Check if build was successful
if ($LASTEXITCODE -ne 0) {
    Write-Error "LLVM build failed. Check the compiler errors above."
    exit $LASTEXITCODE
}

Write-Host "`n=========================================" -ForegroundColor Green
Write-Host " LLVM build completed successfully!"         -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Green