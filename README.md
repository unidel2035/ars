# ARS — 3D FPS Game

3D шутер от первого лица на Godot 4.

## Как запустить

1. Скачай [Godot 4.3+](https://godotengine.org/download)
2. Открой Godot → Import → выбери файл `project.godot` из этой папки
3. Нажми F5 (или кнопку Play)

## Управление

- **WASD** — движение
- **Мышь** — обзор
- **ЛКМ** — стрельба
- **R** — перезарядка
- **Esc** — освободить курсор

## Структура проекта

```
project.godot          — файл проекта Godot
scenes/
  main.tscn            — главная сцена (комната)
  player.tscn          — игрок (камера + коллизия)
  bullet.tscn          — пуля
  enemy.tscn           — враг
scripts/
  player.gd            — логика игрока (движение, стрельба)
  bullet.gd            — логика пули
  enemy.gd             — логика врага
  hud.gd               — интерфейс (HP, патроны)
```
