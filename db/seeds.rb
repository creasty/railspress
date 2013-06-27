
user = User.new(
  name: "Admin User #{i + 1}",
  email: "user.#{i + 1}@admin.com",
  password: '12345678',
  password_confirmation: '12345678',
)
user.admin = true
user.save


5.times do |i|
  User.create(
    name: "Test User #{i + 1}",
    email: "user.#{i + 1}@test.com",
    password: '12345678',
    password_confirmation: '12345678',
  )
end

10.times do |i|
  Post.create(
    title: "Post Title #{i + 1}",
    content: "post content #{i + 1}",
    status: i % 5 == 0 ? 0 : 1,
    user_id: user.id
  )
end
