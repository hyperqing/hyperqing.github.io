# input your command here
cnpm install -g hexo
cnpm install
cd themes/suka && cnpm i --production
cd ../..
hexo deploy --generate
git clone  https://18820133523:498236act,@e.coding.net/clyoko/hexo_blog_static.git
cp -r hexo_blog_static/.git public/.git
cd public
git config --global user.email "469379004@qq.com"
git config --global user.name "HyperQing"
git add *
git commit -m "Build by Aliyun"
git push origin master