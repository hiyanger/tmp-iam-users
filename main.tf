# IAMグループの作成
resource "aws_iam_group" "tmp" {
  name = "tmp"
}

# AdministratorAccessポリシーをグループにアタッチ
resource "aws_iam_group_policy_attachment" "admin_access" {
  group      = aws_iam_group.tmp.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# IAMユーザーの作成
resource "aws_iam_user" "users" {
  count         = local.users
  name          = "user-${format("%02d", count.index + 1)}" 
  force_destroy = true
}

# ユーザーをグループに追加
resource "aws_iam_user_group_membership" "user_group_membership" {
  count  = local.users
  user   = aws_iam_user.users[count.index].name
  groups = [aws_iam_group.tmp.name]
}

# IAMユーザーのログインプロファイル
resource "aws_iam_user_login_profile" "user_login_profile" {
  count                   = local.users
  user                    = aws_iam_user.users[count.index].name
  password_length         = 8
  password_reset_required = false
}

# 作成されたユーザーとそのパスワードを出力
output "user_passwords" {
  value = {
    for idx in range(0, local.users) :
    aws_iam_user.users[idx].name => aws_iam_user_login_profile.user_login_profile[idx].password
  }
  sensitive = false
}