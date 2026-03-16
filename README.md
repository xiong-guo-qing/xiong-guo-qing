# xiong-guo-qing

这个仓库用于存放通用的 AI 编程助手规则与模板。

## 主要文件

- `AI-RULES.md`：全局通用规则，包含工作流、安全规则、记忆模型、沟通方式等
- `AI-PROJECT-RULES-template.md`：项目级规则模板，用于补充某个具体项目的上下文、边界和约定

## 记忆模型

本仓库采用双层记忆模型：

- **短期记忆**：用于保存会话状态、临时约束、调试过程、任务中间记录
- **长期记忆（basic-memory）**：用于保存稳定、已验证、可复用的知识

推荐在具体项目中使用如下短期记忆目录结构：

```text
memory/
  inbox.md
  daily/
  tasks/
```

## 脚本仓库

可复用脚本已迁移到独立仓库：

- HTTPS：`https://github.com/xiong-guo-qing/scripts`
- SSH：`git@github.com:xiong-guo-qing/scripts.git`

当前仓库现在主要只保留规则和模板，不再存放共享脚本。

### 如何获取共享脚本

#### 使用 SSH 克隆

```bash
git clone git@github.com:xiong-guo-qing/scripts.git
```

#### 或使用 HTTPS 克隆

```bash
git clone https://github.com/xiong-guo-qing/scripts.git
```

#### 后续更新脚本

```bash
cd scripts
git pull
```

### 脚本仓库包含的内容

独立脚本仓库目前包含例如：
- OpenClaw WSL 启动 / 停止脚本
- Windows 辅助脚本
- `windows-java-service/` 相关维护脚本

## 说明

- `AI-RULES.md` 是通用、工具无关的主规则文件
- `AI-PROJECT-RULES-template.md` 是项目级覆盖模板
- 共享脚本独立维护，避免和规则仓库混在一起
