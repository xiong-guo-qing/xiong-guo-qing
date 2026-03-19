# xiong-guo-qing

这个仓库用于存放通用的 AI 编程助手规则与模板。

## 主要文件

- `AI-RULES.md`：全局通用规则，包含工作流、安全规则、记忆模型、沟通方式等
- `AI-RULES-SHORT.md`：适合 system prompt / repo prompt / 简短提示词场景的精简版规则
- `AI-PROJECT-RULES.md`：项目级规则模板，用于补充某个具体项目的上下文、边界和约定

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
