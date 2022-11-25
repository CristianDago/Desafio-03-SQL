-- BASE DE DATOS

CREATE DATABASE "desafio3-Cristian-Gallardo-133";
\c desafio3-Cristian-Gallardo-133

-- TABLAS

CREATE TABLE usuarios(id SERIAL PRIMARY KEY, email VARCHAR, nombre VARCHAR, apellido VARCHAR, rol VARCHAR);
CREATE TABLE posts(id SERIAL PRIMARY KEY, titulo VARCHAR, contenido TEXT, fecha_creacion TIMESTAMP, fecha_actualizacion TIMESTAMP, destacado BOOLEAN, usuario_id BIGINT);
CREATE TABLE comentarios(id SERIAL PRIMARY KEY, contenido TEXT, fecha_creacion TIMESTAMP, usuario_id BIGINT, post_id BIGINT);

INSERT INTO usuarios(email, nombre, apellido, rol)
VALUES ('cris.gallardos@gmail.com', 'Cristián', 'Gallardo', 'Administrador');
INSERT INTO usuarios(email, nombre, apellido, rol)
VALUES ('mardones.pablo@gmail.com', 'Pablo', 'Mardones', 'Usuario');
INSERT INTO usuarios(email, nombre, apellido, rol)
VALUES ('hernan.vonmarttens@gmail.com', 'Hernan', 'Von Marttens', 'Usuario');
INSERT INTO usuarios(email, nombre, apellido, rol)
VALUES ('joaquin@rocketmedia.cl', 'Joaquín', 'Arce', 'Usuario');
INSERT INTO usuarios(email, nombre, apellido, rol)
VALUES ('naiomi99@hotmail.com', 'Maricarmen', 'Sánchez', 'Usuario');

INSERT INTO posts(titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES ('Primer post', 'Primer post del sitio', '2000-01-01', '2000-01-02', true, 1);
INSERT INTO posts(titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES ('Segundo post', 'Segundo post del sitio', '2000-01-03', '2000-01-04', true, 1);
INSERT INTO posts(titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES ('Tercer post', 'Tercer post del sitio', '2000-01-05', '2000-01-06', true, 2);
INSERT INTO posts(titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES ('Cuarto Post', 'Cuarto post del sitio', '2000-01-07', '2000-01-08', false, 3);
INSERT INTO posts(titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES ('Quinto Post', 'Quinto post del sitio', '2000-01-09', '2000-01-10', false, null);

INSERT INTO comentarios(contenido, fecha_creacion, usuario_id, post_id)
VALUES ('Primer comentario', '2000-01-03', 1, 1);
INSERT INTO comentarios(contenido, fecha_creacion, usuario_id, post_id)
VALUES ('Segundo comentario', '2000-01-05', 2, 1);
INSERT INTO comentarios(contenido, fecha_creacion, usuario_id, post_id)
VALUES ('Tercer comentario', '2000-01-07', 3, 1);
INSERT INTO comentarios(contenido, fecha_creacion, usuario_id, post_id)
VALUES ('Cuarto comentario', '2000-01-09', 1, 2);
INSERT INTO comentarios(contenido, fecha_creacion, usuario_id, post_id)
VALUES ('Quinto comentario', '2000-01-11', 2, 2);

-- Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas. Nombre e email del usuario junto al título y contenido del post.

SELECT usuarios.email, posts.titulo, posts.contenido FROM posts
INNER JOIN usuarios ON posts.usuario_id = usuarios.id;

-- Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id y debe ser seleccionado dinámicamente.

SELECT posts.id, posts.titulo, posts.contenido FROM posts 
INNER JOIN usuarios ON posts.usuario_id = usuarios.id
WHERE usuarios.rol = 'Administrador';

-- Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario

SELECT usuarios.id, usuarios.email, COUNT(posts.usuario_id) FROM posts
RIGHT JOIN usuarios ON posts.usuario_id = usuarios.id
GROUP BY usuarios.id, usuarios.email;

-- Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email.

SELECT usuarios.email FROM posts
RIGHT JOIN usuarios ON posts.usuario_id = usuarios.id
GROUP BY usuarios.email
ORDER BY count(posts.usuario_id) DESC
LIMIT 1;

-- Muestra la fecha del último post de cada usuario.

SELECT usuarios.nombre, MAX(posts.fecha_creacion) FROM posts
INNER JOIN usuarios ON posts.usuario_id = usuarios.id
GROUP BY usuarios.nombre;

-- Muestra el título y contenido del post (artículo) con más comentarios. 

SELECT posts.titulo, posts.contenido FROM posts 
LEFT JOIN comentarios ON posts.id = comentarios.post_id
GROUP BY posts.titulo, posts.contenido
ORDER BY COUNT(comentarios.id) DESC
LIMIT 1;

-- Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de CADA COMENTARIO (LOS 5 COMENTARIOS (3 en el primer post y 2 en el segundo post como se indica en las instrucciones del desafio)) asociado a los posts mostrados, junto con el email del usuario que lo escribió (2 comentarios escritos por usuario 1, 2 escritos por usuario 2 y 1 escrito por usuario 3).

SELECT posts.titulo AS "Título del post", posts.contenido AS "Contenido del post", comentarios.contenido AS "Comentario", usuarios.email
FROM posts
LEFT JOIN comentarios ON posts.id = comentarios.post_id
INNER JOIN usuarios ON comentarios.usuario_id = usuarios.id;

-- Muestra el contenido del último comentario de cada usuario.

SELECT c1.fecha_creacion, c1.contenido, c1.usuario_id FROM comentarios c1
INNER JOIN (SELECT MAX(fecha_creacion) AS fecha_creacion, usuario_id FROM comentarios GROUP BY usuario_id) AS c2 ON c2.usuario_id = c1.usuario_id
AND c2.fecha_creacion = c1.fecha_creacion;

-- Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT usuarios.email FROM usuarios
LEFT JOIN posts ON usuarios.id = posts.usuario_id
GROUP BY usuarios.email HAVING count(posts.usuario_id) = 0;

