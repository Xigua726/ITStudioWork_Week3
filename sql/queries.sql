USE bookshop;

-- q1 查询库存为 0 的书名和库存
SELECT title,stock FROM books WHERE stock=0;

-- q2 按价格降序取前三本，同价时按 id 升序
SELECT * FROM books ORDER BY price DESC, id ASC LIMIT 3;

-- q3 查询价格在 20 到 40 之间的书（含边界）
SELECT * FROM books WHERE price BETWEEN 20 AND 40 ORDER BY id;

-- q4 JOIN 查每本书的书名、作者名和价格
SELECT b.title, a.name AS author,b.price
FROM books AS b
JOIN authors AS a ON b.author_id = a.id
ORDER BY b.id;

-- q5 先 SELECT 确认，再把你指定的一本有库存的书库存减 1；不要减成负数
SELECT * FROM books WHERE id = 1;
UPDATE books SET stock = stock - 1 WHERE id = 1 AND stock > 0;

-- q6 插入一条唯一标记的临时书，确认后按条件删除它，不删除其他书
INSERT INTO books (title, author_id, price, stock, published_at)
VALUES(
    '临时书',
    (SELECT id FROM authors WHERE name = '鲁迅' LIMIT 1),
    39.80,
    10,
    '2024-01-01'
);
SELECT * FROM books;
SELECT * FROM books WHERE title = '临时书';
DELETE FROM books WHERE title = '临时书';
SELECT * FROM books;


