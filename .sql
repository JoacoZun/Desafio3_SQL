-- Active: 1729882593511@@127.0.0.1@5432@desafio3_joaquin_zuniga_743

-- CREATE DATABASE desafio3_Joaquin_Zuniga_743;
CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rol VARCHAR(50) NOT NULL
);

INSERT INTO Usuarios (email, nombre, apellido, rol) VALUES
('admin@example.com', 'Admin', 'User', 'administrador'),
('user1@example.com', 'User1', 'Last1', 'usuario'),
('user2@example.com', 'User2', 'Last2', 'usuario'),
('user3@example.com', 'User3', 'Last3', 'usuario'),
('user4@example.com', 'User4', 'Last4', 'usuario');

CREATE TABLE Posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    destacado BOOLEAN DEFAULT FALSE,
    usuario_id BIGINT REFERENCES Usuarios(id)
);

INSERT INTO Posts (titulo, contenido, destacado, usuario_id) VALUES
('Post 1', 'Contenido del post 1', TRUE, 1),
('Post 2', 'Contenido del post 2', TRUE, 1),
('Post 3', 'Contenido del post 3', FALSE, 2),
('Post 4', 'Contenido del post 4', FALSE, 3),
('Post 5', 'Contenido del post 5', FALSE, NULL);

CREATE TABLE Comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT REFERENCES Usuarios(id),
    post_id BIGINT REFERENCES Posts(id)
);

INSERT INTO Comentarios (contenido, usuario_id, post_id) VALUES
('Comentario 1 para post 1', 1, 1),
('Comentario 2 para post 1', 2, 1),
('Comentario 3 para post 1', 3, 1),
('Comentario 1 para post 2', 1, 2),
('Comentario 2 para post 2', 2, 2);

-- Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post
SELECT u.nombre, u.email, p.titulo, p.contenido
FROM Usuarios u
JOIN Posts p ON u.id = p.usuario_id;

-- Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id.
SELECT p.id, p.titulo, p.contenido
FROM Posts p
JOIN Usuarios u ON p.usuario_id = u.id
WHERE u.rol = 'administrador';

-- Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM Usuarios u
LEFT JOIN Posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

 --Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT u.email
FROM Usuarios u
JOIN Posts p ON u.id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;

--Muestra la fecha del último post de cada usuario.
SELECT u.id, u.email, MAX(p.fecha_creacion) AS ultima_fecha
FROM Usuarios u
JOIN Posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- Muestra el título y contenido del post (artículo) con más comentarios.
SELECT p.titulo, p.contenido
FROM Posts p
JOIN Comentarios c ON p.id = c.post_id
GROUP BY p.id
ORDER BY COUNT(c.id) DESC
LIMIT 1;

--Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.
SELECT p.titulo, p.contenido AS post_contenido, c.contenido AS comentario_contenido, u.email
FROM Posts p
JOIN Comentarios c ON p.id = c.post_id
JOIN Usuarios u ON c.usuario_id = u.id;

--Muestra el contenido del último comentario de cada usuario.
SELECT c.usuario_id, c.contenido
FROM Comentarios c
JOIN (
    SELECT usuario_id, MAX(fecha_creacion) AS ultima_fecha
    FROM Comentarios
    GROUP BY usuario_id
) ultimos ON c.usuario_id = ultimos.usuario_id AND c.fecha_creacion = ultimos.ultima_fecha;

--Muestra los emails de los usuarios que no han escrito ningún comentario.
SELECT u.email
FROM Usuarios u
LEFT JOIN Comentarios c ON u.id = c.usuario_id
GROUP BY u.id
HAVING COUNT(c.id) = 0;