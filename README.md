
RailsPress
==========

Rails, Backbone.js, Flight.js, RequireJS, Flat Design...  
これらをいっぺんに習得しようと、勉強用に作ったブログ CMS です。  
管理画面しか作ってません(笑)

今見ると酷い実装です。。。

いつまでも Private Repo だと邪魔なので  
永遠に未完成のまま公開。


Get Started
-----------

### Setup

	$ bower install
	$ bundle
	$ bundle exec rake db:create
	$ bundle exec rake db:migrate


### Configure

`config/application.sample.yml` を `config/application.yml` にリネームして、  
必要な項目を埋めて下さい。


### Import dump data

`/_dumps` 以下に sql のダンプデータと、public/system の zip ファイルがあるのでこれらをインポートして下さい。


Login to admin page
-------------------

`http://localhost:3000/admin` にアクセス

<table>
	<tr>
		<th>Username</th>
		<th>Password</th>
	</tr>
	<tr>
		<td>creasty</td>
		<td>12345678</td>
	</tr>
</table>


