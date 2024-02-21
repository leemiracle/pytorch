- 主要用于在 PyTorch 中进行性能测试和基准测试。这些性能测试旨在评估 PyTorch 在不同硬件平台上的性能表现，以及不同操作和模型在 PyTorch 中的执行速度。
  - 性能测试脚本：包括针对不同硬件平台（如 CPU、GPU、TPU 等）的性能测试脚本，以及针对不同操作和模型的性能测试脚本。
  - 基准测试工具：包括一些基准测试工具，用于测量 PyTorch 在执行不同操作和模型时的运行时间、内存占用等性能指标。
  - 性能测试结果：benchmarks 目录下的代码还包括了一些性能测试结果的记录和分析工具，用于分析和展示 PyTorch 在不同硬件平台上的性能表现，以及不同操作和模型的执行速度。
# PyTorch Benchmarks

This folder contains scripts that produce reproducible timings of various PyTorch features.

It also provides mechanisms to compare PyTorch with other frameworks.

## Setup environment
Make sure you're on a machine with CUDA, torchvision, and pytorch installed. Install in the following order:
```
# Install torchvision. It comes with the pytorch stable release binary
conda install pytorch torchvision -c pytorch

# Install the latest pytorch master from source.
# It should supersede the installation from the release binary.
cd $PYTORCH_HOME
python setup.py build develop

# Check the pytorch installation version
python -c "import torch; print(torch.__version__)"
```

## Benchmark List

Please refer to each subfolder to discover each benchmark suite. Links are provided where descriptions exist:

* [Fast RNNs](fastrnns/README.md)
* [Dynamo](dynamo/README.md)
* [Functional autograd](functional_autograd_benchmark/README.md)
* [Instruction counts](instruction_counts/README.md)
* [Operator](operator_benchmark/README.md)
* [Overrides](overrides_benchmark/README.md)
* [Sparse](sparse/README.md)
* [Tensor expression](tensorexpr/HowToRun.md)
