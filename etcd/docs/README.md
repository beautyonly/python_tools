# etcd文档概述
# Page Contents 本节内容
  etcd是一个分布式key-value store设备，旨在可靠快速保存并提供对关键数据的访问。它通过distributed locking(分布式锁), leader elections(领导选举), and write barriers(书写障碍)实现可靠的分布式协调。一个etcd集群用于高可用性和永久数据存储和检索。

# Communicating with etcd v2 与etcd v2沟通
读取和写入etcd keyspace是通过一个简单的RESTful HTTP API完成的，或者使用特定于语言的库来完成，这些库将HTTP API用较高级别的基元包装起来。

## Reading and Writing 读取和写入
- Client API Documentation 客户端API文档
- Libraries, Tools, and Language Bindings 库、工具和语言绑定
- Admin API Documentation 管理API文档
- Members API 成员API

## Security, Auth, Access control 安全性、身份验证、访问控制
- Security Model 安全模型
- Auth and Security 身份验证和安全性
- Authentication Guide 认证指南

# etcd v2 Cluster Administration etcd v2集群管理
配置值分布在集群中供应用程序读取。值可以通过编程方式更改，智能应用程序可以自动重新配置。您将不再需要在每台机器上运行配置管理工具，以便更改单个配置值。

## General Info 基本信息
- etcd Proxies etcd代理
- Production Users 生产用户
- Admin Guide 管理员指南
- Configuration Flags 配置标志
- Frequently Asked Questions 经常问的问题

## Initial Setup
- Tuning etcd Clusters 调整etcd机器
- Discovery Service Protocol 发现服务协议
- Running etcd under Docker 在Docker下运行etcd

## Live Reconfiguration 实时重新配置
- Runtime Configuration 运行时配置

## Debugging etcd 调试etcd
- Metrics Collection 度量标准集合
- Error Code 错误代码
- Reporting Bugs 报告错误

## Migration 迁移
- Upgrade etcd to 2.3
- Upgrade etcd to 2.2
- Upgrade to etcd 2.1
- Snapshot Migration (0.4.x to 2.x) 快照迁移
- Backward Compatibility 向后兼容
