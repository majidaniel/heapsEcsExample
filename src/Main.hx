import resources.*;
import ecs.Universe;
import systems.*;

//Haxe Entry point
class Main extends hxd.App {
	var universe:Universe;

	override function init() {
		//Initializes "res" folder
		hxd.Res.initEmbed();
		engine.backgroundColor = 0xffffff;

		//ECS library, creates a collection of systems that we'll use later to run
		universe = Universe.create({
			entities: 1024,
			phases: [
				{
					name: 'game-logic',
					systems: [GameSystem, MoveSystem, CollisionDetectionSystem, CollisionResolutionSystem]
				},
				{
					name: 'rendering',
					systems: [RenderSystem]
				}
			]
		});

		// Setup resources (aka Singletons) for use in ECS retrieval
		var displayResources = new DisplayResources(s2d);
		var inputCapturer = new InputCapture();
		var gameState = new GameState();
		universe.setResources(displayResources, inputCapturer,gameState);
	}

	//Runs every frame via heaps.io
	override function update(dt:Float) {
		universe.update(dt);
	}

	//Default haxe entry function
	static function main() {
		new Main();
	}
}
