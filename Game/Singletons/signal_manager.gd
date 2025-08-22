extends Node

signal on_create_bullet(position: Vector2, direction: Vector2, speed: float, lifespan: float, object_type: Constants.ObjectType)

signal on_create_object(position: Vector2, object_type: Constants.ObjectType)

signal on_coin_collect(value: int)

signal on_checkpoint_hit(position: Vector2)

signal on_completion(level:int, score: int)

signal on_enemy_kill(value: int)

signal on_enemy_shoot()

signal on_enemy_hit()

signal on_hp_update(hp: int)

signal on_score_update(score: int)

signal on_toggle()

signal on_respawn()

signal on_death()

signal on_player_jump()

signal on_enemy_jump()

signal on_start_next()

signal on_go_next()

signal on_level_start()
