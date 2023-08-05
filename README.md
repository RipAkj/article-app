# README

Database


Article(id: integer, title: string, description: string, created_at: datetime, updated_at: datetime, user_id: integer, like: integer, comment: integer, topic: string)

User(id: integer, username: string, email: string, created_at: datetime, updated_at: datetime, password_digest: string, encrypted_password: string, reset_password_token: string, reset_password_sent_at: datetime, remember_created_at: datetime)

Friendship(id: integer, follower_id: integer, followed_id: integer, created_at: datetime, updated_at: datetime)

Fetch all articles by all users
http://127.0.0.1:3000/articles    (GET)

Fetch all users
http://127.0.0.1:3000/users        (GET)

Fetch a particular article         (GET)
http://127.0.0.1:3000/articles/9

Fetch a particular user
http://127.0.0.1:3000/users/9       (GET)

Create a user
http://127.0.0.1:3000/signup        (POST)
And this should go in body, form raw, type data
{
    "username":"Rails App",
    "email":"rails@google.com",
    "password_digest":"123456"
}

Edit a user
http://127.0.0.1:3000/users/9        (PUT)
And this should go in body, form raw, type data (the updated data)
{
    "username":"Ruby App",
    "email":"ruby@google.com",
    "password_digest":"123456"
}

Create an article
http://127.0.0.1:3000/articles?id=9   (POST)
id=9 is the id of user creating the article
{
    "title":"New Title",
    "description":"New Description",
    "like":9,
    "comment":21
}

Edit the article
http://127.0.0.1:3000/articles/19   (PUT)
19 is the id of the article u want to update
{
    "title":"New Title1",
    "description":"New Description",
    "like":9,
    "comment":21
}

Destroy an article
http://127.0.0.1:3000/articles/19   (DELETE)
19 is the id of the article u want to destroy

Sort all articles by number of Likes
http://127.0.0.1:3000/sortByLike    (GET)

Sort all articles by number of Comments
http://127.0.0.1:3000/sortByComment  (GET)

Search articles by title or a part of title name
http://127.0.0.1:3000/articleSearch?s=tit   (GET)

Search articles by title or a part of topic name
http://127.0.0.1:3000/topicSearch?s=sports

Suggested top 5 articles based on no of likes and comments
http://127.0.0.1:3000/topArticles            (GET)

Suggest similar articles based to a given article
http://127.0.0.1:3000/similarArticles?id=5   (GET)
5 is the article id

List all the types of topic of all articles
http://127.0.0.1:3000/listTopic               (GET)

List all articles of a particular user
http://127.0.0.1:3000/showArticle?id=2        (GET)
where 2 is the id of the user

Search user based on part or full of their username
http://127.0.0.1:3000/userSearch?s=app         (GET)
where app is the part of the username we want to search


http://127.0.0.1:3000/recommendedArticles?id=11
where 11 is the id of user for whom we want these recommended articles
Showing this by finding who our user follows on app and showing their created articles

Follow someone, here user1 is the one who is following user2
http://127.0.0.1:3000/friendships?user1_id=7&user2_id=9   (POST)

Show followers of user id 11
http://127.0.0.1:3000/showFollowers?id=11    (GET)

Show following of user id 11
http://127.0.0.1:3000/showFollowing?id=11     (GET)

User id 7 unfollows user id 9 here
http://127.0.0.1:3000/friendships/7?user2_id=9   (DELETE)


Log in
http://127.0.0.1:3000/login      (POST)
{
    "email":"rails@google.com",
    "password_digest":"123456"
}

Log out
http://127.0.0.1:3000/logout    (DELETE)
