# Entrega SQL — Gimnasio FitVal

## Parte A — Diseño

### A1 — Tres tipos de clave

**1. ¿Qué columnas no se pueden repetir nunca?**

Las columnas `id`, `dni` y `email`, porque identifican de manera única a cada socio.

**2. ¿Cuál es la clave primaria? ¿Cuáles son las claves alternativas?**

La clave primaria es `id`. Las claves alternativas son `dni` y `email`, ya que tienen la restricción `UNIQUE`.

**3. ¿Qué columna apunta a otra tabla? ¿A cuál?**

La columna `plan_id` es una clave foránea que referencia a `planes(id)`.

**4. ¿Por qué utilizamos un ID numérico en lugar del DNI como clave primaria?**

Porque es un identificador interno más sencillo para relacionar tablas y no depende de un dato personal como el DNI, que podría necesitar corregirse.

### A2 — Tipos de relaciones

| Pareja | Un A, ¿cuántos B? | Un B, ¿cuántos A? | Relación |
|---|---|---|---|
| Planes – socios | Muchos | Uno | 1:N |
| Socios – tarjetas | Una como máximo | Uno | 1:1 |
| Monitores – clases | Muchas | Uno | 1:N |
| Socios – clases | Muchas | Muchos | N:M |
| Monitores – especialidades | Muchas | Muchos | N:M |

### A3 — Relación 1:N: monitores y clases

**1. Las dos preguntas**

Un monitor puede impartir muchas clases, pero cada clase tiene un único monitor. Por tanto, es una relación 1:N.

**2. ¿Dónde va la clave ajena?**

En la tabla `clases`, con el nombre `monitor_id`, que referencia a `monitores(id)`.

**3. ¿Qué pasaría si la colocáramos en el lado equivocado?**

Si añadiéramos `clase_id` a `monitores`, tendríamos un problema:

| id | nombre | clase_id |
|---|---|---|
| 1 | Carla Navarro | 1, 4, 7 |

Carla imparte varias clases, por lo que necesitaríamos guardar varios identificadores en una sola columna, algo que no corresponde al diseño relacional planteado.

**4. ¿Debe ser NOT NULL?**

Sí, porque el enunciado establece que cada clase tiene obligatoriamente un monitor asignado.

**5. ¿Qué tabla se crea primero?**

Primero `monitores` y después `clases`, porque `clases.monitor_id` depende de `monitores(id)`.

### A4 — Relación 1:1: socios y tarjetas

**1. ¿Qué ocurre si quitamos UNIQUE de socio_id?**

Un mismo socio podría tener varias tarjetas asociadas.

Por ejemplo:

| id | codigo | socio_id |
|---|---|---|
| 1 | TJ-0001 | 1 |
| 2 | TJ-0099 | 1 |

Esto convertiría la relación en 1:N, porque un socio podría tener varias tarjetas.

**2. ¿Qué evita cada UNIQUE?**

- `codigo UNIQUE` impide que dos tarjetas tengan el mismo código.
- `socio_id UNIQUE` impide que un socio tenga más de una tarjeta.

**3. Otro ejemplo de relación 1:1**

Una persona y su expediente médico individual, suponiendo que cada persona tenga un único expediente y cada expediente pertenezca a una sola persona.

Crearía una tabla `personas` y otra `expedientes_medicos`, colocando `persona_id` como clave foránea con `UNIQUE` en `expedientes_medicos`.

### A5 — Relación N:M: monitores y especialidades

**1. Las dos preguntas**

Un monitor puede tener muchas especialidades y una especialidad puede pertenecer a muchos monitores.

Por tanto, la relación es N:M.

**2. ¿Qué tablas necesitamos?**

Las tablas `monitores`, `especialidades` y una tabla intermedia llamada `monitor_especialidades`.

**3. Columnas y claves**

**monitores**

- `id`: PRIMARY KEY.
- `dni`: UNIQUE.
- `nombre`.
- `email`: UNIQUE.

**especialidades**

- `id`: PRIMARY KEY.
- `nombre`: UNIQUE.

**monitor_especialidades**

- `id`: PRIMARY KEY.
- `monitor_id`: FOREIGN KEY hacia `monitores(id)`.
- `especialidad_id`: FOREIGN KEY hacia `especialidades(id)`.
- `UNIQUE (monitor_id, especialidad_id)`.

**4. ¿Qué evita UNIQUE en la tabla intermedia?**

Impide que un mismo monitor tenga asignada dos veces la misma especialidad.

**5. ¿Qué tienen en común reservas y monitor_especialidades?**

Ambas son tablas intermedias que resuelven relaciones N:M y contienen dos claves foráneas.

La diferencia es que `reservas` también almacena `fecha_reserva`, mientras que `monitor_especialidades` solamente relaciona monitores con especialidades.

### A6 — ¿Dónde va la clave ajena?

**1. País – ciudad**

Relación 1:N. Un país puede tener muchas ciudades, pero cada ciudad pertenece a un país. La clave foránea `pais_id` estaría en `ciudades`.

**2. Persona – pasaporte**

Relación 1:1, suponiendo un único pasaporte vigente por persona. Pondría `persona_id` como clave foránea con `UNIQUE` en `pasaportes`.

**3. Alumno – asignatura**

Relación N:M. Un alumno puede cursar varias asignaturas y una asignatura puede tener varios alumnos. Crearía una tabla intermedia `matriculas` con `alumno_id` y `asignatura_id`.

**4. Cliente – pedido**

Relación 1:N. Un cliente puede realizar varios pedidos, pero cada pedido pertenece a un cliente. La clave foránea `cliente_id` estaría en `pedidos`.

**5. Película – actor**

Relación N:M. Una película tiene varios actores y un actor puede aparecer en varias películas.

Crearía una tabla intermedia `pelicula_actores`, con `pelicula_id`, `actor_id` y `personaje`, porque el personaje corresponde a la participación del actor en una película concreta.

**6. Autor – libro**

Depende de si se permite que un libro tenga varios autores.

Si cada libro tiene un único autor, sería 1:N y pondría `autor_id` en `libros`.

Si se permite que un libro tenga varios autores, sería N:M y crearía una tabla intermedia `autor_libros`.

**7. Furniro: usuario – pedido**

Relación 1:N. Un usuario puede realizar varios pedidos, pero cada pedido pertenece a un usuario.

La clave foránea `user_id` estaría en `orders`.

**8. Furniro: pedido – producto**

Relación N:M. Un pedido puede contener varios productos y un producto puede aparecer en diferentes pedidos.

Crearía una tabla intermedia `order_products`, con `order_id`, `product_id`, `cantidad` y `precio_unitario`, para almacenar los detalles de cada producto dentro de un pedido.

---

## Parte B

### B3 — Restricciones

#### B3.1 — Socio con un plan inexistente

**Predicción inicial:** Pensaba que PostgreSQL crearía automáticamente el plan 99.

**Resultado:** PostgreSQL rechazó la inserción.

**Error:** `insert or update on table "socios" violates foreign key constraint "socios_plan_id_fkey"`

**Detalle:** `Key (plan_id)=(99) is not present in table "planes".`

**Traducción:** El plan con identificador 99 no existe en la tabla `planes`.

**Restricción:** FOREIGN KEY (`socios_plan_id_fkey`).

**Explicación:** La clave foránea exige que el plan exista previamente. PostgreSQL no crea automáticamente los registros relacionados.

#### B3.2 — Email duplicado

**Predicción:** PostgreSQL rechazará la inserción porque `ana@gym.com` ya está registrado.

**Resultado:** PostgreSQL rechazó la inserción.

**Error:** `duplicate key value violates unique constraint "socios_email_key"`

**Detalle:** `Key (email)=(ana@gym.com) already exists.`

**Traducción:** El correo electrónico ya existe y no puede repetirse.

**Restricción:** UNIQUE (`email`).

**Explicación:** La restricción UNIQUE impide que dos socios tengan el mismo correo electrónico.

#### B3.3 — Segunda tarjeta para Ana

**Predicción inicial:** Pensaba que PostgreSQL permitiría registrar otra tarjeta porque tenía un código diferente.

**Resultado:** PostgreSQL rechazó la inserción porque Ana ya tiene una tarjeta asignada.

**Error:** `duplicate key value violates unique constraint "tarjetas_socio_id_key"`

**Detalle:** `Key (socio_id)=(1) already exists.`

**Traducción:** El valor de `socio_id` está duplicado porque ya existe una tarjeta asociada al socio con ID 1.

**Restricción:** `UNIQUE (socio_id)`.

**Explicación:** Aunque el código de la tarjeta sea diferente, la restricción `UNIQUE` impide que un mismo socio tenga más de una tarjeta.

#### B3.4 — Reserva duplicada

**Predicción:** PostgreSQL rechazará la inserción porque
Ana ya tiene reservada la clase con ID 1.

**Resultado:** PostgreSQL rechazó la inserción.

**Error:** duplicate key value violates unique constraint
"reservas_socio_id_clase_id_key"

**Detalle:** Key (socio_id, clase_id)=(1, 1) already exists.

**Traducción:** La combinación del socio 1 y la clase 1
ya existe en la tabla de reservas.

**Restricción:** UNIQUE (socio_id, clase_id).

**Explicación:** La restricción UNIQUE impide que un mismo
socio reserve dos veces la misma clase, aunque utilice
una fecha de reserva diferente.

#### B3.5 — Reserva de una clase inexistente

**Predicción:** PostgreSQL rechazará la reserva porque
la clase con ID 50 no existe.

**Resultado:** PostgreSQL rechazó la inserción.

**Error:** insert or update on table "reservas" violates
foreign key constraint "reservas_clase_id_fkey"

**Detalle:** Key (clase_id)=(50) is not present in table "clases".

**Traducción:** La clase con identificador 50 no existe
en la tabla clases.

**Restricción:** FOREIGN KEY (clase_id).

**Explicación:** La clave foránea obliga a que cada reserva
esté asociada a una clase existente. Como la clase 50
no existe, PostgreSQL impide registrar la reserva.

#### B3.6 — Borrar el plan Básico

**Predicción:** PostgreSQL rechazará la eliminación
porque hay socios asociados al plan Básico.

**Resultado:** PostgreSQL rechazó la eliminación.

**Error:** update or delete on table "planes" violates
foreign key constraint "socios_plan_id_fkey" on table "socios".

**Detalle:** Key (id)=(1) is still referenced from table "socios".

**Traducción:** No se puede eliminar el plan con ID 1
porque sigue siendo utilizado por socios.

**Restricción:** FOREIGN KEY (socios_plan_id_fkey).

**Explicación:** La clave foránea plan_id de la tabla socios
impide eliminar un plan mientras existan socios asociados
a él.

#### B3.7 — Borrar el plan Mañanas

**Predicción:** PostgreSQL permitirá eliminar el plan Mañanas porque ningún socio lo tiene asignado.

**Resultado:** PostgreSQL eliminó correctamente el plan.

**Mensaje:** `DELETE 1`.

**Explicación:** La eliminación fue posible porque ningún registro de la tabla `socios` hacía referencia a ese plan.

#### B3.8 — ¿Por qué B3.6 falla y B3.7 funciona?

B3.6 falla porque el plan Básico está asociado a varios socios y la clave foránea `plan_id` impide eliminarlo.

En cambio, B3.7 funciona porque ningún socio utiliza el plan Mañanas, por lo que eliminarlo no rompe ninguna relación entre las tablas.

### B4.11 — Pregunta sobre las reservas

No es un error que Ana Pérez aparezca tres veces en la consulta B4.6.

Esto ocurre porque Ana tiene tres reservas diferentes: Spinning, Pilates y Crossfit. Como la consulta muestra una fila por cada reserva, su nombre aparece una vez por cada clase reservada.

Aunque Ana solo tiene un registro en la tabla `socios`, puede tener varias reservas porque existe una relación 1:N entre `socios` y `reservas`.

### B5.6 — Dar de baja a Pablo

Al intentar eliminar directamente a Pablo de la tabla socios, PostgreSQL rechazó la operación porque existía una tarjeta asociada a él.

El error indicó que se estaba incumpliendo la clave foránea tarjetas_socio_id_fkey.

Para eliminarlo correctamente, primero borré su reserva de la tabla reservas, después su tarjeta de la tabla tarjetas y, finalmente, su registro de la tabla socios.

Este orden es necesario porque las claves foráneas impiden eliminar un socio mientras existan registros en otras tablas que hagan referencia a él.

### B6 — Explicaciones

#### B6.1 — ¿Qué diferencia hay entre una clave primaria y una clave UNIQUE?

La clave primaria (`PRIMARY KEY`) identifica de forma única cada registro de una tabla y no permite valores `NULL`. En cambio, la restricción `UNIQUE` impide valores duplicados, pero puede permitir valores `NULL`. Además, una tabla solo puede tener una clave primaria, mientras que puede tener varias restricciones `UNIQUE`.

#### B6.2 — ¿Por qué una clave ajena sí puede repetirse?

Una clave ajena (`FOREIGN KEY`) puede repetirse porque varios registros pueden estar relacionados con un mismo registro de otra tabla. Por ejemplo, varios socios pueden tener el mismo `plan_id` porque pertenecen al mismo plan del gimnasio.

#### B6.3 — En una relación 1:N, ¿en qué lado va la clave ajena? ¿Por qué no en el otro?

La clave ajena se coloca en el lado N, porque cada registro de ese lado debe indicar a qué registro del lado 1 pertenece.

Por ejemplo, `monitor_id` está en la tabla `clases`, ya que un monitor puede impartir varias clases. Si colocáramos `clase_id` en `monitores`, no podríamos representar fácilmente todas las clases de un mismo monitor.

#### B6.4 — ¿Qué convierte una relación 1:N en una 1:1?

Añadir la restricción `UNIQUE` a la clave foránea impide que varios registros hagan referencia al mismo registro de otra tabla, convirtiendo la relación 1:N en una relación 1:1.

Por ejemplo, en la tabla `tarjetas`, `socio_id` tiene `UNIQUE` para garantizar que cada socio pueda tener como máximo una tarjeta.

#### B6.5 — ¿Por qué una relación N:M necesita una tabla intermedia?

Una relación N:M necesita una tabla intermedia porque varios registros de una tabla pueden relacionarse con varios registros de otra. Esta tabla contiene dos claves foráneas que permiten almacenar cada relación.

Por ejemplo, `monitor_especialidades` relaciona a los monitores con sus especialidades, permitiendo que un monitor tenga varias especialidades y que una especialidad pertenezca a varios monitores.

#### B6.6 — ¿Por qué fecha_reserva está en reservas y no en socios ni en clases?

La columna `fecha_reserva` pertenece a la tabla `reservas` porque indica cuándo un socio realizó una reserva para una clase concreta.

No debe estar en `socios` porque un socio puede realizar varias reservas en fechas diferentes, ni en `clases` porque varios socios pueden reservar una misma clase en días distintos.