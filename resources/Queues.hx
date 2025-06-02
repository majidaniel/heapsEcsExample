package resources;

class ExampleRequest1 extends BaseRequest {
	var val1:Int = 1;

	public function new(val) {
		this.val1 = val;
	}
}

class BaseRequest {
	public function debugInfo() {}
}

class Queues {
	private var queues:Map<String, Array<Dynamic>> = new Map();
	private var queueByType:Map<String, Array<Dynamic>> = new Map();

	public function new() {}

	public function queueRequest<T:BaseRequest>(req:T) {
		var cl:String = Type.getClassName(Type.getClass(req));
		if (!queueByType.exists(cl))
			queueByType.set(cl, new Array());
		queueByType.get(cl).push(req);
	}

	public function getRequests<T:BaseRequest>(cls:Class<T>):Array<T> {
		var cl:String = Type.getClassName(cls);
		return cast queueByType.get(cl);
	}

	public function clearRequests<T:BaseRequest>(cls:Class<T>) {
		var cl:String = Type.getClassName(cls);
		if (queueByType.exists(cl)) {
			queueByType.set(cl, new Array());
		}
	}

	public function consumeRequests<T:BaseRequest>(cls:Class<T>):Array<T> {
		var cl:String = Type.getClassName(cls);
		if (queueByType.exists(cl)) {
			var requests = queueByType.get(cl);
			queueByType.remove(cl);
			return cast requests;
		}
		return [];
	}
}
