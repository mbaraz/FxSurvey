package tools.enums {
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	import mx.utils.StringUtil;

	/**
	 * To create and use Enums in Flex applications
	 * you should extend Enum class.<br/>
	 * To define enum values use next signature:<br/>
	 * <b/>public static const [ENUM_NAME]:[YOUR_CLASS] = new [YOUR_CLASS]([ENUM_VALUE]);</b><br/>
	 * for example:<br/>
	 * <listing>public class Layout extends Enum {
	 *     public static const HORIZONTAL:Layout = new Layout('horizontal');
	 *     public static const VERTICAL:Layout = new Layout('vertical');
	 *
	 *     public function Layout(value:String) {
	 *         super(value);
	 * }
	 *}
	 * </listing>
	 **/
	public class Enum {
		private var _name:String;
		private var _value:Number;

		private static var defaultValueGenerator:Number = 0;

		public function Enum() {
			if (isFullyInstantiated(myType)) {
				throw new IllegalOperationError("Enum values could be instantiated only in Enum declaration");
			}
			_value = defaultValueGenerator++;
		}

		private function get myType():Class {
			return Object(this).constructor;
		}

		public final function get name():String {
			if (!_name) {
				_name = resolveName(myType, this);
			}
			return _name;
		}

		public final function toString():String {
			return StringUtil.substitute("{0}.{1}",
					getQualifiedClassName(myType).replace(/.*::/, ''), name);
		}

		private static function resolveName(enumType:Class, value:Enum):String {
			var identificators:Array /* of EnumIdentificator */ = getIdentificators(enumType);
			for each (var identificator:EnumIdentificator in identificators) {
				if (enumType[identificator.name] == value) {
					return identificator.name;
				}
			}
			return null;
		}

		/**
		 * get all available names for specified enum type.
		 * enumType should be a valid Enum
		 *
		 * @returns
		 * Array of String containing all valid names for enum.
		 **/
		private static function getIdentificators(enumType:Class):Array {
			var description:XML = describeType(enumType);

			if (!isEnumClass(description)) {
				throw new TypeError(StringUtil.substitute("{0} is not enum.",
						getQualifiedClassName(enumType)));
			}

			var registeredAlias:Object = new Object();
			var result:Array = [];
			for each (var constant:XML in description..constant) {
				var identificator:EnumIdentificator = new EnumIdentificator();
				identificator.name = constant.@name.toString();
				var aliasCount:int = constant.elements('metadata').(@name == 'Alias').length();
				if (aliasCount != 0) {
					if (aliasCount > 1) {
						throw new TypeError("Enum value could have only one alias");
					}
					identificator.alias = constant.elements('metadata').(@name == 'Alias').elements('arg')[0].@value;
					if (identificator.alias == null ||
							identificator.alias == '') {
						throw new TypeError("Empty enum value alias not allowed");
					}
					if (registeredAlias.hasOwnProperty(identificator.alias.toLowerCase())) {
						throw new TypeError("Enum value alias should differ from other aliases and enum names");
					}
					registeredAlias[identificator.alias.toLowerCase()] = true;
				}
				registeredAlias[identificator.name.toLowerCase()] = true;
				result.push(identificator);
			}
			return result;
		}

		public static function getValues(enumType:Class):Array {
			var result:Array = [];
			var identificators:Array /* of EnumIdentificator */ = getIdentificators(enumType);
			for each (var identificator:EnumIdentificator in identificators)
				result.push(enumType[identificator.name]);

			return result;
		}

		/**
		 * get identificator of specified enum corresponding to its name or alias assigned by [Alias('alias')] metadata
		 **/
		public static function valueOf(enumType:Class, nameOrAlias:String):* {
			var identificators:Array /* of EnumIdentificator */ = getIdentificators(enumType);
			if (!nameOrAlias) {
				return getDefault(enumType);
			}
			for each (var candidateId:EnumIdentificator in identificators) {
				if (nameOrAlias.toLowerCase() == candidateId.name.toLowerCase()) {
					return enumType[candidateId.name];
				}
				if (candidateId.alias &&
						candidateId.alias.toLowerCase() == nameOrAlias.toLowerCase()) {
					return enumType[candidateId.name];
				}
			}
			return getDefault(enumType);
		}

		private static function isEnumClass(description:XML):Boolean {
			var enumTypeName:String = getQualifiedClassName(Enum);
			var interfaceNode:XMLList = description..extendsClass.(@type == enumTypeName);
			return interfaceNode.length() > 0;
		}

		private static function getDefault(enumType:Class):* {
			var description:XML = describeType(enumType);
			var defaults:XMLList = description..constant.(elements('metadata').(@name == 'Default').length() != 0);
			if (defaults.length() > 1) {
				throw new TypeError(StringUtil.substitute("{0} is invalid enum. There should be at most one default value.",
						getQualifiedClassName(enumType)));
			}
			if (defaults.length() == 0) {
				return null;
			}
			return enumType[defaults[0].@name.toString()];
		}

		private static function isFullyInstantiated(enumType:Class):Boolean {
			return getValues(enumType).every(testNotNull, null);
		}

		private static function testNotNull(item:*, index:int,
				array:Array):Boolean {
			return item != null;
		}
	}
}