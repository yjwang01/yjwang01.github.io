@echo off

rd /S /q public
rd /S /q resources

git add .
set /p var= "Please input commit message: "

git commit -m "%var%"
git push origin master
