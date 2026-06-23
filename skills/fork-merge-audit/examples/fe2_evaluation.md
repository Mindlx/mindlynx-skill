# FE² 评估示例

## 模块：告警系统（完整记录）

### 上游数据

| 提交 | 类型 | 说明 |
|:-----|:-----|:-----|
| `296f0f17` | feat | P5 技术指标告警规则（MA/RSI/MACD/KDJ/CCI）|
| `2caa1292` | feat | P6 持仓与自选股告警 |

### FE² 矩阵

| 轴 | 判决 | 证据 |
|:--:|:----:|:-----|
| CORRECT | UPSTREAM_WINS | 上游有 5 种指标告警；本地仅 3 类通用告警 |
| MAINTAIN | TIE | 都遵循 service/repo 模式 |
| PERFORM | TIE | 相似评估模式 |
| INTEGRATE | TIE | 都通过 FastAPI 暴露 |
| ROBUST | TIE | 本地有线程安全冷却/指纹去重 |

### 决策

**HYBRID** — 按需从上游 `alert_indicators.py` 选取指标计算逻辑（3-5 小时）
