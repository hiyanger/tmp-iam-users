## memo

瞬間的にIAMユーザーを大量に作る場合などの利用を想定

 - パスワードは8文字（password_lengthで変更可）
 - パスワードはoutputとtfstateに出力されるので注意（tfstateだと & は\u0026になるもよう）
 - 初回パスワード変更もなし（password_reset_required / ensitive = false）
 - variableはユーザー数（users）のみで利用
