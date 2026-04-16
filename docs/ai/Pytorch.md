## 1.Pytorch入门
### 1.1.张量Tensor
+ 本质上就是多维数组
+ 0维的叫标量，1维的叫向量，2维的叫矩阵
+ 张量可以在GPU和CPU上进行计算
+ 张量支持自动求导

```python
import torch
x=torch.tensor([1,2])
print(f"{x}")
print(f"{x.shape}")
y=torch.zeros(size)#创建全0张量
z=x.view(2)#改变张量的形状，返回张量的视图
k=x.reshape(1,2)
```

> **torch.reshape(tensor, new_shape)  
**
>
> + `**reshape**`<font style="color:rgb(6, 6, 7);">：更灵活，可以处理更多的形状转换场景，但在某些情况下会返回一个新的张量。</font>
>
> **  
****tensor.view(new_shape)**
>
> + `**view**`<font style="color:rgb(6, 6, 7);">：速度更快，因为它只是重新安排已有数据的内存视图，不会创建新的数据布局。</font>
>

### 1.2.自动求导Autograd
```python
import torch
# requires_grad=True 告诉 PyTorch：请追踪在这个变量上发生的所有操作！
w = torch.tensor([1.0], requires_grad=True)
x = torch.tensor([2.0])
b = torch.tensor([3.0], requires_grad=True)


y = w * x + b  

y.backward()

# 查看梯度 (dy/dw = x = 2)
print(w.grad) # 输出 tensor([2.])
```

### 1.3.构建模型nn.Module
+ pytorch 提供了`torch.nn`库，封装了各种层和激活函数

```python
import torch.nn as nn

class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        # 定义两层全连接网络
        # Linear 就是 y = Wx + b
        self.layer1 = nn.Linear(in_features=10, out_features=5)
        self.relu = nn.ReLU() # 激活函数
        self.layer2 = nn.Linear(in_features=5, out_features=1)

    def forward(self, x):
        x = self.layer1(x)
        x = self.relu(x)   
        x = self.layer2(x) 
        return x

model = Net()
print(model)
```

输出：

```python
Net(
  (layer1): Linear(in_features=10, out_features=5, bias=True)
  (relu): ReLU()
  (layer2): Linear(in_features=5, out_features=1, bias=True)
)
```

#### 1.3.1.torch.nn
> 下面就介绍一些我目前阶段可能会用到的神经网络层吧
>

+ **全连接层：**`torch.nn.Linear`

```python
linear_layer = torch.nn.Linear(in_features=10, out_features=5)
```

+ **卷积层：**`nn.Conv2d`

```python
# 定义卷积层
# in_channels=3: 输入图片的通道数 
# out_channels=16: 输出多少种特征图
# kernel_size=3: 这里是 3x3 像素
# stride=1: 步长
# padding=1: 补全
conv_layer = nn.Conv2d(in_channels=3, out_channels=16,
                       kernel_size=3, stride=1,
                       padding=1)
```

+ **池化层：**`nn.MaxPool2d`

```python
pool_layer = nn.MaxPool2d(kernel_size=2, stride=2)
```

#### 1.3.2Sequential
+ `nn.Sequential` 是 PyTorch 中的一个“容器”，它的作用是把多个层（Layer）按顺序打包在一起。
+ 适用于只有一条路的网络

```python
self.features = nn.Sequential(
            nn.Conv2d(1, 20, 5),
            nn.ReLU(),
            nn.Conv2d(20, 64, 5),
            nn.ReLU()
        )
```

### 1.4.损失函数
> 当然有很多损失函数，这里我就列举两个，其余的需要的时候再查即可
>

+ **交叉熵损失：**`torch.nn.CrossEntropyLoss`
    - 适用于输出是一个概率分布向量的问题，分类任务

```python
criterion = nn.CrossEntropyLoss()
outputs = torch.tensor([[2.0, 1.0, 0.1], 
                        [0.5, 1.0, 5.0]])
targets = torch.tensor([0, 2])
loss = criterion(outputs, targets)
```

+ **均方误差损失：**`nn.MSELoss`
    - 适用于回归任务

```python
criterion = nn.MSELoss()
predictions = torch.tensor([100.0, 200.0])
targets = torch.tensor([110.0, 195.0])
loss = criterion(predictions, targets)
```



### 1.5.加载数据集
几个小概念：

+ epoch：训练的轮数
+ Batch_Size：一个批次的样本数
+ Iteration：一轮训练的批次数

```python
from torch.utils.data import Dataset #抽象类，只能继承
from torch.utils.data import DataLoader #实例类
```

+ 定义类

```python
import torch
from torch.utils.data import Dataset

class MyCustomDataset(Dataset):
    def __init__(self, data_list, transform=None):
        self.data = data_list
        self.transform = transform

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        # 1. 根据索引获取原始数据（例如图片路径和标签）
        sample = self.data[idx] 
        # 假设 sample 是 (image_array, label)
        image, label = sample 
        
        # 2. 如果有预处理（比如转 Tensor，归一化），在这里做
        if self.transform:
            image = self.transform(image)
            
        # 3. 返回这对数据
        return image, label
```

+ 加载数据集

```python
train_loader = DataLoader(dataset=dataset,
batch_size=32,
shuffle=True,#是否乱序
num_workers=2)#几个线程同时读取文件
```

### 1.6更新参数/优化器
> 这里主要运用到的库是`torch.optim`，里面放了很多优化器，下面介绍SGD和Adam
>

+ `SGD`：最基础的梯度下降法

```python
#model.parameters()是告诉优化器要更新哪些参数
#lr是学习率
#momentum是动量，小幅度的优化了梯度下降的缺点
optimizer = optim.SGD(model.parameters(), lr=0.01, momentum=0.9)
```

+ `Adam`：是能自适应调节的优化器

```python
optimizer = optim.Adam(model.parameters(), lr=0.001)
```

> 下面展示一下示例
>

```python
import torch
import torch.optim as optim


optimizer = optim.Adam(model.parameters(), lr=0.001)

for input, target in dataloader:
    output = model(input)
    loss = loss_fn(output, target)
    # 1.梯度清零
    optimizer.zero_grad()
    # 2.反向传播 
    loss.backward()
    # 3.参数更新
    optimizer.step()
```

> 梯度清零：pytorch中默认会把梯度累加
>

