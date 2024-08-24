package systems;

import components.Position;
import ecs.System;
import components.PlayerControlled;
import components.Collided;
import components.Goal;
import resources.GameState;
import resources.DisplayResources;

//System that resolves collissions
//Keeping this separate from the detection system let's us layer on game logic into colissions without complicating the detection engine
class CollisionResolutionSystem extends System {
	@:fastFamily var playerCollided:{collided:Collided, playerControlled:PlayerControlled, position:Position};

	@:fullFamily var goalReached:{
		requires:{collided:Collided, goal:Goal},
		resources:{displayResources:DisplayResources, gameState:GameState}
	};

	override function update(_dt:Float) {
		iterate(playerCollided, entity -> {
			position.x = 0;
			position.y = 0;
			universe.removeComponents(entity, collided);
		});

		setup(goalReached, {
			iterate(goalReached, entity -> {
				gameState.levelComplete = true;
				universe.removeComponents(entity, collided);
			});
		});
	}
}
