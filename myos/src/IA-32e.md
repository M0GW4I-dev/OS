# IA-32eモード
## サブモード
- コンパティビリティモード(プロテクトモードのプログラムを動かせるモード
- 64-bitモード(64bitアドレッシングモードで実行できるモード)

# REX prefixes
REX prefixesとは、64bitモードにおける命令の接頭辞のこと。

全ての命令が、REX prefixを必要とするわけではない。prefixが必要なのは、拡張レジスタ(the extended registers)か64-bitのオペランドを使うとき。

# nop
何もしない命令。コードは0x90。シングルバイトnop命令とマルチバイトnop命令があるらしい。

# Out-of-Order実行
速度の為に命令の実行順序を変えたりする方法。OoOとかO-o-Oとかって書かれる。逆に、In-Order実行がある。In-Order実行は、従来の通り、Fetch, Read, Execute, Write だが、Out-of-Order実行はこの通りではない。
