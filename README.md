# shrug
shrug是一个模拟Git版本管理器的初级产品，使用shell编程，已实现init、add、remove、commit等功能
### 具体实现功能
+ ./shrug-init                                                                        　　初始化
+ ./shrug-add g                                                                       　　添加文件g
+ ./shrug-commit -m 'first commit'                                                    　　提交并备注为'first commit'
+ ./shrug-commit -a -m commit-3                                                       　　使索引中已经存在的所有文件在提交之前将其当前目录中的内容添加到索引中
+ ./shrug-log                                                                         　　提交日志
+ ./shrug-show 0:b                                                                    　　显示第一次提交的b文件
+ ./shrug-status                                                                      　　显示当前文件夹、索引以及仓库状态
+ ./shrug-rm e                                                                        　　删除文件e
+ ./shrug-rm -f e                                                                     　　强制删除文件e
+ ./shrug-branch b1                                                                   　　创建一个新分支b1
+ ./shrug-checkout b1                                                                 　　转换到分支b１

### Example
#### subset 0

