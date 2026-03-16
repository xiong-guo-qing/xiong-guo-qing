# AI-RULES-SHORT.md

适用于通用 AI 编程助手的精简规则版。
未特别说明时，细则以 `AI-RULES.md` 为准。

## 核心要求

- 先理解任务，再动手修改
- 先搜索上下文，再做判断
- 优先最小正确改动，不做无关重构
- 修改后尽可能验证，再说明结果
- 不编造 API、路径、配置、测试结果和命令执行结果
- 产生稳定结论后，写回长期知识；过程性信息优先写入短期记忆

## 默认读取顺序

1. `AI-RULES.md`
2. `AI-PROJECT-RULES.md`（若存在）
3. `README.md`
4. `memory/tasks/<current-task>.md`（若存在）
5. `memory/inbox.md`
6. 最近 1-2 天的 `memory/daily/YYYY-MM-DD.md`
7. 长期知识：
   - `projects/<project>/overview.md`
   - `architecture.md`
   - `conventions.md`
   - `commands.md`
   - `gotchas.md`
   - `decisions/`
   - 必要时再查 `playbooks/`、`stack/`、`snippets/`

## 记忆规则

### 短期记忆
优先用于保存：
- 当前任务目标
- 临时约束
- 中间状态
- 排查过程
- 待验证判断
- 当前中断点和下一步

推荐位置：

```text
memory/
  inbox.md
  daily/
  tasks/
  scratch/
```

### 长期记忆
只保存：
- 已验证、稳定、可复用的知识
- 项目约定、架构事实、常用命令、关键决策、已验证排障经验

推荐位置：

```text
ai-memory/
  projects/<project>/
    overview.md
    architecture.md
    conventions.md
    commands.md
    gotchas.md
  decisions/
  playbooks/
  stack/
  snippets/
```

## 写入原则

- 过程先写短期，结论再进长期
- 长期知识优先补充已有文档，不要随意新建碎片文件
- 长期文档命名尽量稳定：`overview.md`、`architecture.md`、`conventions.md`、`commands.md`、`gotchas.md`
- 如果短期信息与长期知识冲突，先判断是临时例外还是长期规则变化，再决定是否更新长期层

## 输出要求

汇报结果时尽量包含：
- 原因 / 背景
- 修改内容
- 影响范围
- 验证结果
- 风险 / 后续建议
