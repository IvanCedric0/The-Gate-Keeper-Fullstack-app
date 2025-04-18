-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : dim. 23 mars 2025 à 23:58
-- Version du serveur : 9.1.0
-- Version de PHP : 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `gatekeeper_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `admins`
--

DROP TABLE IF EXISTS `admins`;
CREATE TABLE IF NOT EXISTS `admins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `admins`
--

INSERT INTO `admins` (`id`, `username`, `password`, `created_at`) VALUES
(1, 'admin', '$2b$10$30eJX2EBRfO1TTOy0xG.X.PqcJpiIoEb0Gi.P/o/lKVCf7Oeh43o.', '2025-03-21 12:11:37');

-- --------------------------------------------------------

--
-- Structure de la table `students`
--

DROP TABLE IF EXISTS `students`;
CREATE TABLE IF NOT EXISTS `students` (
  `id` int NOT NULL,
  `fullname` text NOT NULL,
  `major` text NOT NULL,
  `photo` text NOT NULL,
  `qr_code` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `students`
--

INSERT INTO `students` (`id`, `fullname`, `major`, `photo`, `qr_code`) VALUES
(107678, 'Yeo Mickael', 'Computer science', 'https://i.ibb.co/MD66LxB5/927baf8fed24.jpg', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHQAAAB0CAYAAABUmhYnAAAAAklEQVR4AewaftIAAAK7SURBVO3BQY7cQAwEwSxC//9yeo88NSBIM17TjIg/WGMUa5RijVKsUYo1SrFGKdYoxRqlWKMUa5RijVKsUYo1SrFGKdYoxRrl4qEkfJPKSRLuUDlJwjepPFGsUYo1SrFGuXiZypuScIfKHUnoVE5U3pSENxVrlGKNUqxRLj4sCXeo3JGEO1TelIQ7VD6pWKMUa5RijXLxn0lCpzJJsUYp1ijFGuViGJUuCZ1Kl4RO5V9WrFGKNUqxRrn4MJVvSsJJEjqVJ1R+k2KNUqxRijXKxcuS8DepdEnoVLokdConSfjNijVKsUYp1igXD6n8y1ROVP4lxRqlWKMUa5T4gweS0Kl0SXiTykkS7lA5ScKbVD6pWKMUa5RijRJ/8KIkdCp3JKFT6ZJwonKShCdUnkjCicoTxRqlWKMUa5T4gweS8CaVLgknKl0STlS6JHQqXRJOVJ5IQqfyRLFGKdYoxRrl4sNUTpJwotIl4UTlJAknSThR+c2KNUqxRinWKBcfloQTlZMkdCp3JKFT6ZLQqZwkoVPpknCHypuKNUqxRinWKBcPqXySykkSTlS+SeVvKtYoxRqlWKPEHzyQhG9SOUnCHSpdEjqVkyR0Kl0SOpUuCZ3KE8UapVijFGuUi5epvCkJJ0noVLokdConKidJeCIJncqbijVKsUYp1igXH5aEO1Q+KQmdSpeETqVT6ZJwh8onFWuUYo1SrFEuhknCHUk4SUKn0ql0SehUvqlYoxRrlGKNcvGfUemS0Kl0SeiS0Kl0Kn9TsUYp1ijFGuXiw1Q+SaVLwkkSTpJwonKShE6lS0Kn8qZijVKsUYo1ysXLkvBNSehUuiR0Kl0SOpWTJHQqnUqXhE7lk4o1SrFGKdYo8QdrjGKNUqxRijVKsUYp1ijFGqVYoxRrlGKNUqxRijVKsUYp1ijFGqVYo/wBv/Aa4TAUoh4AAAAASUVORK5CYII='),
(166487, 'Kouame Paul Eliel', 'Computer science', 'https://i.ibb.co/20SHZM7h/e6b946de3f09.jpg', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHQAAAB0CAYAAABUmhYnAAAAAklEQVR4AewaftIAAAK9SURBVO3BQW7sWAwEwSxC979yTi+5eoAgte3PYUT8YI1RrFGKNUqxRinWKMUapVijFGuUYo1SrFGKNUqxRinWKMUapVijFGuUi4eS8JNU7khCp3JHEn6SyhPFGqVYoxRrlIuXqbwpCU+onCShUzlReVMS3lSsUYo1SrFGufiyJNyhckcSTlS6JLwpCXeofFOxRinWKMUa5WIYlS4JnUqXhEmKNUqxRinWKBfDqfyfFGuUYo1SrFEuvkzlJyWhU+mS0Kk8ofKXFGuUYo1SrFEuXpaE36TSJaFT6ZLQqZwk4S8r1ijFGqVYo8QP/mFJuENlsmKNUqxRijVK/OCBJHQqXRLepHKShDtUTpLwJpVvKtYoxRqlWKNcvCwJnUqXhDtU7lDpknCShDtUTpJwRxI6lSeKNUqxRinWKPGDFyXhROWOJDyhcpKETqVLwolKl4ROpUtCp/KmYo1SrFGKNUr84IEkdCrflITfpPKmJHQqTxRrlGKNUqxRLh5SOUnCHSpdEk5UuiR0KidJ6FROktCpdEk4UfmmYo1SrFGKNcrFl6k8oXKShE7lL1E5UXlTsUYp1ijFGiV+8EASfpLKE0noVLokdConSehUuiR0Kl0SOpUnijVKsUYp1igXL1N5UxJOktCpnKicqJwk4YkkdCpvKtYoxRqlWKNcfFkS7lB5Igl3qHRJ6FQ6lS4Jd6h8U7FGKdYoxRrlYhiVkyR0SThJQqfSqXRJ6FR+UrFGKdYoxRrlYrgkdCpdEjqVLgldEjqVTuU3FWuUYo1SrFEuvkzlm1S6JHQqXRJOknCicpKETqVLQqfypmKNUqxRijXKxcuS8JOS0Kl0SehUuiR0KidJ6FQ6lS4Jnco3FWuUYo1SrFHiB2uMYo1SrFGKNUqxRinWKMUapVijFGuUYo1SrFGKNUqxRinWKMUapVij/Afe5CHaPy4mqwAAAABJRU5ErkJggg=='),
(106807, 'Kouame Ivan Cedric', 'Computer science', 'https://i.ibb.co/LKmV4Q5/584166b44ea7.jpg', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHQAAAB0CAYAAABUmhYnAAAAAklEQVR4AewaftIAAAK6SURBVO3BQW7sWAwEwSxC979yjpdcPUBQy/7NYUT8wRqjWKMUa5RijVKsUYo1SrFGKdYoxRqlWKMUa5RijVKsUYo1SrFGKdYoFw8l4TepdEnoVO5IQqfSJeE3qTxRrFGKNUqxRrn4MJVPSsKJykkSOpUnVD4pCZ9UrFGKNUqxRrl4WRLuULkjCScqb0rCHSpvKtYoxRqlWKNcfDmVO5LQqUxSrFGKNUqxRrkYJgmdykkSOpVvVqxRijVKsUa5eJnKm5Lwl1T+JcUapVijFGuUiw9Lwl9S6ZLQqXRJuCMJ/7JijVKsUYo1ysVDKn9JpUvCJ6l8k2KNUqxRijXKxUNJ6FS6JHQqdyThRKVT6ZJwonJHEjqVkyR0Kl0SOpUnijVKsUYp1igXD6mcqHRJ6FROVE6ScKLSJaFT6ZLwRBL+UrFGKdYoxRol/uCDktCpdEl4k8pJEu5Q6ZLwSSqfVKxRijVKsUaJP3hREjqVNyXhDpUuCXeonCShU+mS0Kk8UaxRijVKsUa5eCgJnUqn0iXhRKVLQqfSJeFEpUtCl4QnktCp/KVijVKsUYo1SvzBF0tCp9IloVN5UxJOVN5UrFGKNUqxRrl4KAm/SeUkCZ+UhE7liSR0Kp9UrFGKNUqxRrn4MJVPSsKJykkSTpLQqXQqJ0noVE6S8KZijVKsUYo1ysXLknCHym9SOUlCp9KpdEm4IwmdyhPFGqVYoxRrlIv/mSR0Kl0STpLQqdyh8qZijVKsUYo1ysWXS8KJSpeELgknKl0SuiScqHRJOFF5olijFGuUYo1y8TKVN6l0SbhDpUtCl4QTlS4JXRJOVD6pWKMUa5RijRJ/8EASfpNKl4ROpUvCN1F5olijFGuUYo0Sf7DGKNYoxRqlWKMUa5RijVKsUYo1SrFGKdYoxRqlWKMUa5RijVKsUYo1yn/Oug723r+Q8wAAAABJRU5ErkJggg=='),
(166487, 'Koun Mamadou', 'POLS', 'https://i.ibb.co/JWQmgmdw/7f2b7733b8e2.jpg', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHQAAAB0CAYAAABUmhYnAAAAAklEQVR4AewaftIAAAK9SURBVO3BQW7sWAwEwSxC979yTi+5eoAgte3PYUT8YI1RrFGKNUqxRinWKMUapVijFGuUYo1SrFGKNUqxRinWKMUapVijFGuUi4eS8JNU7khCp3JHEn6SyhPFGqVYoxRrlIuXqbwpCU+onCShUzlReVMS3lSsUYo1SrFGufiyJNyhckcSTlS6JLwpCXeofFOxRinWKMUa5WIYlS4JnUqXhEmKNUqxRinWKBfDqfyfFGuUYo1SrFEuvkzlJyWhU+mS0Kk8ofKXFGuUYo1SrFEuXpaE36TSJaFT6ZLQqZwk4S8r1ijFGqVYo8QP/mFJuENlsmKNUqxRijVK/OCBJHQqXRLepHKShDtUTpLwJpVvKtYoxRqlWKNcvCwJnUqXhDtU7lDpknCShDtUTpJwRxI6lSeKNUqxRinWKPGDFyXhROWOJDyhcpKETqVLwolKl4ROpUtCp/KmYo1SrFGKNUr84IEkdCrflITfpPKmJHQqTxRrlGKNUqxRLh5SOUnCHSpdEk5UuiR0KidJ6FROktCpdEk4UfmmYo1SrFGKNcrFl6k8oXKShE7lL1E5UXlTsUYp1ijFGiV+8EASfpLKE0noVLokdConSehUuiR0Kl0SOpUnijVKsUYp1igXL1N5UxJOktCpnKicqJwk4YkkdCpvKtYoxRqlWKNcfFkS7lB5Igl3qHRJ6FQ6lS4Jd6h8U7FGKdYoxRrlYhiVkyR0SThJQqfSqXRJ6FR+UrFGKdYoxRrlYrgkdCpdEjqVLgldEjqVTuU3FWuUYo1SrFEuvkzlm1S6JHQqXRJOknCicpKETqVLQqfypmKNUqxRijXKxcuS8JOS0Kl0SehUuiR0KidJ6FQ6lS4Jnco3FWuUYo1SrFHiB2uMYo1SrFGKNUqxRinWKMUapVijFGuUYo1SrFGKNUqxRinWKMUapVij/Afe5CHaPy4mqwAAAABJRU5ErkJggg=='),
(107509, 'Kone Cheick', 'BBA', 'https://i.ibb.co/Lzt2CjBS/6c6fb42b7362.jpg', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHQAAAB0CAYAAABUmhYnAAAAAklEQVR4AewaftIAAAK2SURBVO3BQW7sWAwEwSxC979yjpdcPUCQur+HZkT8wRqjWKMUa5RijVKsUYo1SrFGKdYoxRqlWKMUa5RijVKsUYo1SrFGKdYoFw8l4ZtUTpLQqZwkoVPpkvBNKk8Ua5RijVKsUS5epvKmJNyhcofKHSpvSsKbijVKsUYp1igXH5aEO1TuSEKn0iXhDpU7knCHyicVa5RijVKsUS7+GJUuCZMUa5RijVKsUS6GScJfVqxRijVKsUa5+DCVb1I5SUKn8oTKb1KsUYo1SrFGuXhZEn6TJHQqXRI6lZMk/GbFGqVYoxRrlPiD/7EknKj8JcUapVijFGuU+IMHktCpdEl4k8pJEu5QOUnCm1Q+qVijFGuUYo1y8Y+pfJJKl4QuCXeonCThJAknKk8Ua5RijVKsUS4eUjlRuSMJJypPqHRJ6FS6JHRJ6FROVE6S8KZijVKsUYo1ysVDSehUuiTcoXJHEk6ScEcSTlR+s2KNUqxRijXKxUMqT6h0SThR6VS6JHQqJ0noVE6S0KnckYRO5U3FGqVYoxRrlIsPU7lD5Y4knCShU/mmJHQqn1SsUYo1SrFGuXgoCd+k0qnckYROpUtCp9KpdEnoVLoknCShU3miWKMUa5RijXLxMpU3JeEkCZ1Kl4RO5UTlJAlPJKFTeVOxRinWKMUa5eLDknCHyhNJ6FS6JHQqXRI6lU6lS8IdKp9UrFGKNUqxRrn445JwkoROpVPpktCpfFOxRinWKMUa5eKPUemS0Kl0SeiS0Kl0Kv9SsUYp1ijFGuXiw1Q+SaVLwkkSTpJwonKShE6lS0Kn8qZijVKsUYo1ysXLkvBNSThJQqfSJaFTOUlCp9KpdEnoVD6pWKMUa5RijRJ/sMYo1ijFGqVYoxRrlGKNUqxRijVKsUYp1ijFGqVYoxRrlGKNUqxRijXKf3xND/KdrDCvAAAAAElFTkSuQmCC');

-- --------------------------------------------------------

--
-- Structure de la table `student_logs`
--

DROP TABLE IF EXISTS `student_logs`;
CREATE TABLE IF NOT EXISTS `student_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `entry_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `exit_time` timestamp NULL DEFAULT NULL,
  `status` enum('entered','exited') DEFAULT 'entered',
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `student_logs`
--

INSERT INTO `student_logs` (`id`, `student_id`, `entry_time`, `exit_time`, `status`) VALUES
(1, 106807, '2025-03-23 09:00:30', '2025-03-23 09:06:17', 'exited'),
(2, 106807, '2025-03-23 10:48:55', '2025-03-23 23:43:57', 'exited'),
(3, 106807, '2025-03-23 10:49:04', '2025-03-23 23:43:57', 'exited');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
