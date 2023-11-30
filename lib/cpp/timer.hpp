// Copyright (c) 2023 innodisk Crop.
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

#ifndef __TIMER__
#define __TIMER__

#include <unistd.h>
namespace jhh
{
    class timer{
        public:
        void start(){
            time_start = std::chrono::high_resolution_clock::now();
        };
        void section(const char* info = ""){
            end(info);
            start();
        };
        void end(const char* info = ""){
            time_end = std::chrono::high_resolution_clock::now();
            duration = time_end - time_start;
            std::cout << (duration.count() / 1000) << " " << info << std::endl;
        };
        private:
        std::chrono::high_resolution_clock::time_point time_start;
        std::chrono::high_resolution_clock::time_point time_end;
        std::chrono::duration<double, std::milli> duration;
    };  
} // namespace name

#endif /* __TIMER__ */