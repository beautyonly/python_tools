# for-beginners 初学者的核心概念
# WHAT IS CONTINUOUS INTEGRATION (CI)? 什么是持续集成CI?
持续集成是一种经常合并小代码更改的做法，而不是在开发周期结束时进行大的更改。我们的目标是通过以较小的增量进行开发和测试来构建更健康的软件。这是Travis CI进来的地方。

作为一个持续集成平台，Travis CI通过自动构建和测试代码更改来支持您的开发过程，为变更的成功提供即时反馈。Travis CI还可以通过管理部署和通知来自动化开发过程的其他部分。

# CI BUILDS AND AUTOMATION: BUILDING, TESTING, DEPLOYING CI构建和自动化：构建、测试和部署
当您运行构建时，Travis CI会将您的GitHub存储库复制到一个全新的虚拟环境中，并执行一系列构建和测试代码的任务。如果其中一项或多项任务失败，则认为构建被 破坏。如果没有任何任务失败，构建被认为通过，Travis CI可以将您的代码部署到Web服务器或应用程序主机。

CI构建还可以使您的交付工作流程的其他部分自动化。这意味着您可以使用构建阶段相互依赖工作，设置通知，在构建之后准备 部署以及执行许多其他任务

# BUILDS, JOBS, STAGES AND PHASES 构建、作业、步骤和阶段
在Travis CI文档中，一些常用词具有特定的含义：

- job - 一种自动化过程，将您的存储库克隆到虚拟环境中，然后执行一系列阶段，如编译代码，运行测试等。如果script 阶段的返回代码 不为零，则作业将失败。
- phase - 工作的连续步骤 。例如，该install阶段script位于可选deploy阶段之前的阶段之前。
- build - 一组工作。例如，构建可能有两个作业，每个作业都使用不同版本的编程语言测试项目。一个建立在所有作业完成后结束。
- stage - 作为由多个阶段组成的顺序构建过程的一部分，并行运行的一组作业。

# BREAKING THE BUILD 中断build
当一个或多个作业以未通过的状态完成时，构建被认为中断：

- 差错 -在一个命令before_install，install或before_script 相返回非零退出代码。工作立即停止。
- 失败 - script阶段中的命令返回非零退出代码。作业继续运行直到完成。
- 取消 - 用户在完成之前取消作业。

我们的“ 常见构建问题”页面是开始排查构建破裂的原因的好地方。


# INFRASTRUCTURE AND ENVIRONMENT NOTES 基础设施和环境说明
Travis CI提供了几种不同的基础设施环境，因此您可以选择最适合您项目的设置：

- Container-based - 是新项目的默认设置。它是一个运行在容器中的Linux Ubuntu环境。它开始比启用sudo的环境中更快，但资源少，不支持使用sudo，setuid或setgid。
- Sudo-enabled - 此Linux Ubuntu环境运行在完整的虚拟机上。它开始有点慢，但它有更多的计算资源，并支持使用sudo，setuid和setgid。
- OS X - 使用OS X操作系统的多个版本之一。这个环境对于构建需要OS X软件的项目很有用，比如用Swift编写的项目。如果您在macOS机器上开发，则不需要使用OS X环境。

有关我们的环境的更多详细信息，请参阅我们的CI环境文档。

现在您已阅读了基本知识，请参阅我们的入门指南，了解如何设置第一个版本的详细信息！
