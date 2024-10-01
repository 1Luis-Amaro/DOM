CREATE TABLE cidades(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(255) NOT NULL,
  estado_id int UNSIGNED NOT NULL,
  area DECIMAL (10, 2),
  PRIMARY KEY (id),
  foreign KEY (estado_id) references estados (id)
);