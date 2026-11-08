extends Node

signal leaderboard_updated
signal made_top_three(rank: int)

const SAVE_PATH := "user://leaderboard.save"
const TOP_COUNT := 3

var all_scores: Array = []
var last_score: int = 0
var last_rank: int = 0

func _ready() -> void:
	load_data()
	
# When the game ends then run this. We want all scores to get stored
func add_score(score: int) -> int:
	var rank := get_rank_for(score)
	last_score = score
	last_rank = rank
	all_scores.append(score)
	save_data()
	leaderboard_updated.emit()
	if rank > 0:
		made_top_three.emit(rank)
	return rank
	
# Check the top 3 Scores
func get_rank_for(score: int) -> int:
	if score <= 0:
		return 0
	var rank := 1
	for s in all_scores:
		if s >= score:
			rank += 1
	return rank if rank <= TOP_COUNT else 0
		
func is_top_score(score: int) -> bool:
	return get_rank_for(score) > 0
	
func get_top_scores(count: int) -> Array:
	var sorted: Array = all_scores.duplicate()
	sorted.sort()
	sorted.reverse()
	return sorted.slice(0, count)

# Get Your Scores
func get_best_score() -> int:
	var top := get_top_scores(1)
	return top[0] if not top.is_empty() else 0
	
func get_last_score() -> int:
	return last_score

func get_last_rank() -> int:
	return last_rank
	
# Functions for saving, loading and clearing data
func clear() -> void:
	all_scores.clear()
	last_score = 0
	last_rank = 0 
	save_data()
	leaderboard_updated.emit()

func save_data() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file : 
		file.store_var({"all_scores": all_scores, "last_score": last_score})
	
		
func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("FILE DOESNT EXIST")
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	print("File!")
	if file: 
		print("FILE EXISTS!")
		var data = file.get_var()
		if data is Dictionary: 
			print("LOADING DATA IN...")
			all_scores.clear()
			for entry in data.get("all_scores", []):
				if entry is Dictionary:
					all_scores.append(int(entry.get("scores", 0)))
				else: 
					all_scores.append(int(entry))
			last_score = data.get("last_score", 0)
