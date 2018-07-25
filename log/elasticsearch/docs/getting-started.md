> [入门](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/getting-started.html#getting-started)

Elasticsearch是一个高度可扩展的开源全文搜索和分析引擎。它允许您快速，近实时地存储，搜索和分析大量数据。它通常用作支持具有复杂搜索功能和需求的应用程序的底层引擎/技术。

以下是Elasticsearch可用于的几个示例用例：

- 您运营一家在线网上商店，让您的客户可以搜索您销售的产品。在这种情况下，您可以使用Elasticsearch来存储您的整个产品目录和库存，并为其提供搜索和自动填充建议。
- 您希望收集日志或交易数据，并且想要分析和挖掘此数据以查找趋势，统计数据，汇总或异常情况。在这种情况下，您可以使用Logstash（Elasticsearch / Logstash / Kibana堆栈的一部分）来收集，汇总和分析数据，然后使用Logstash将此数据提供给Elasticsearch。一旦数据在Elasticsearch中，您就可以运行搜索和聚合来挖掘您感兴趣的任何信息。
- 你运行一个价格提醒平台，它允许精明的顾客指定一条规则，例如“我有兴趣购买特定的电子产品，并且如果在下个月内，任何供应商的产品价格低于$ X，我都会收到通知” 。在这种情况下，您可以缩减供应商价格，将其推入Elasticsearch，并使用其反向搜索（Percolator）功能将价格变动与客户查询进行匹配，并最终在发现匹配时将警报推送给客户。
- 您需要分析/商业智能需求，并且希望快速调查，分析，可视化并针对大量数据提出临时问题（可以考虑数百万或数十亿条记录）。在这种情况下，您可以使用Elasticsearch存储数据，然后使用Kibana（Elasticsearch / Logstash / Kibana堆栈的一部分）来构建自定义仪表板，以便可视化数据对您很重要的各个方面。另外，您可以使用Elasticsearch聚合功能对数据执行复杂的商业智能查询。

在本教程的其余部分中，您将通过获取并运行Elasticsearch，浏览它并执行基本操作（如索引，搜索和修改数据）的过程来指导您。在本教程的最后，您应该对Elasticsearch是什么以及它的工作原理有一个很好的了解，并希望能够启发您，以了解如何使用它来构建复杂的搜索应用程序或从数据中挖掘情报。