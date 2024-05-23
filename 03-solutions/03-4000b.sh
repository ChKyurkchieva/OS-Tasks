mkdir ~/dir5
touch ~/dir5/file1 ~/dir5/file2 ~/dir5/file3
vi ~dir5/file1
vi ~dir5/file2
vi ~dir5/file3
wc -l -w -m ~/dir5/file1 ~/dir5/file2 ~/dir5/file3
wc -l -m ~/dir5/file1 ~/dir5/file2 ~/dir5/file3 | tail -n 1
wc -l ~/dir5/file1 ~/dir5/file2 ~/dir5/file3 | tail -n 1
wc -l ~/dir5/file1 ~/dir5/file2 ~/dir5/file3
