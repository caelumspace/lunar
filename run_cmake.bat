% cmake -B build -S . -G "Visual Studio 17 2022" -A x64 -DBUILD_SHARED_LIBS=OFF
% Configure and build
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -G "Visual Studio 17 2022" -A x64 -DBUILD_SHARED_LIBS=OFF
cmake --build build --config Release

% Install
cmake --install build --config Release
