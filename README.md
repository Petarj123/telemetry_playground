# telemetry_playground
This module was intended to enable runtime monitoring of function calls in selected modules without requiring code changes. While it works as designed, enabling BEAM tracing introduces significant performance overhead, especially on frequently called (“hot path”) functions. 
