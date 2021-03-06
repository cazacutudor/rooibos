' /**
'  * @module ItemGenerator
'  */

' /**
'  * @memberof module:ItemGenerator
'  * @name ItemGenerator
'  * @function
'  * @instance
'  * @param {Dynamic} scheme  - A scheme with desired object structure. Can be 
'  * any simple type, array of types or associative array in form 
'  *
'  * ``` { propertyName1 : "propertyType1"
'  *   propertyName2 : "propertyType2"
'  *   ...
'  *   propertyNameN : "propertyTypeN" }
'  * ```
'  * @description Creates an ItemGenerator instance
'  * @returns {Object} An object according to specified scheme or invalid, if scheme is not valid.
'  */ 
Function ItemGenerator(scheme as object) as Object
  
  this = {}
  
  this.getItem    = RBS_IG_GetItem
  this.getAssocArray  = RBS_IG_GetAssocArray
  this.getArray     = RBS_IG_GetArray
  this.getSimpleType  = RBS_IG_GetSimpleType
  this.getInteger   = RBS_IG_GetInteger
  this.getFloat     = RBS_IG_GetFloat
  this.getString    = RBS_IG_GetString
  this.getBoolean   = RBS_IG_GetBoolean
  
  if not RBS_CMN_IsValid(scheme)
    return invalid
  end if
  
  return this.getItem(scheme)
End Function

' /**
'  * @memberof module:ItemGenerator
'  * @name GetItem
'  * @function
'  * @instance
'  * @param {Dynamic} scheme  - A scheme with desired object structure. Can be 
'  * any simple type, array of types or associative array in form 
'  *
'  * ``` { propertyName1 : "propertyType1"
'  *   propertyName2 : "propertyType2"
'  *   ...
'  *   propertyNameN : "propertyTypeN" }
'  * ```
'  * @description Gets an item according to the schem
'  * @returns {Object}  An object according to specified scheme or invalid if scheme is not one of simple type, array or associative array.
'  */ 
Function RBS_IG_GetItem(scheme as object) as object
  
  item = invalid
  
  if RBS_CMN_IsAssociativeArray(scheme)
    item = m.getAssocArray(scheme)
  else if RBS_CMN_IsArray(scheme)
    item = m.getArray(scheme)
  else if RBS_CMN_IsString(scheme) 
    item = m.getSimpleType(lCase(scheme))
  end if  
  
  return item
End Function

' /**
'  * @memberof module:ItemGenerator
'  * @name GetAssocArray
'  * @function
'  * @instance
'  * @param {Dynamic} scheme  - A scheme with desired object structure. Can be 
'  * any simple type, array of types or associative array in form 
'  *
'  * ``` { propertyName1 : "propertyType1"
'  *   propertyName2 : "propertyType2"
'  *   ...
'  *   propertyNameN : "propertyTypeN" }
'  * ```
'  * @description Generates associative array according to specified scheme.
'  * @returns {Object} An associative array according to specified scheme.
'  */ 
Function RBS_IG_GetAssocArray(scheme as object) as object
  
  item = {}
  
  for each key in scheme
    if not item.DoesExist(key)
      item[key] = m.getItem(scheme[key])
    end if
  end for
  
  return item
End Function

' /**
'  * @memberof module:ItemGenerator
'  * @name GetArray
'  * @function
'  * @instance
'  * @param {Dynamic} An array with desired object types. 
'  *
'  * ``` { propertyName1 : "propertyType1"
'  *   propertyName2 : "propertyType2"
'  *   ...
'  *   propertyNameN : "propertyTypeN" }
'  * ```
'  * @description Generates array according to specified scheme.
'  * @returns {Object} An array according to specified scheme.
'  */ 
Function RBS_IG_GetArray(scheme as object) as object
  
  item = []
  
  for each key in scheme
    item.Push(m.getItem(key))
  end for
  
  return item
End Function

' /**
'  * @memberof module:ItemGenerator
'  * @name GetSimpleType
'  * @function
'  * @instance
'  * @description Generates random value of specified type
'  * @param {Dynamic} typeStr - name of desired object type.
'  * @returns {Object} A simple type object or invalid if type is not supported.
'  */ 
Function RBS_IG_GetSimpleType(typeStr as string) as object
  
  item = invalid
  
  if typeStr = "integer" or typeStr = "int" or typeStr = "roint"
    item = m.getInteger()
  else if typeStr = "float" or typeStr = "rofloat"
    item = m.getFloat()
  else if typeStr = "string" or typeStr = "rostring"
    item = m.getString(10)
  else if typeStr = "boolean" or typeStr = "roboolean"
    item = m.getBoolean()
  end if
  
  return item
End Function

' /**
'  * @memberof module:ItemGenerator
'  * @name GetBoolean
'  * @function
'  * @instance
'  * @description Generates random boolean value.
'  * @returns {Boolean} A random boolean value.
'  */ 
Function RBS_IG_GetBoolean() as boolean
  return RBS_CMN_AsBoolean(Rnd(2) \ Rnd(2))
End Function

' /**
'  * @memberof module:ItemGenerator
'  * @name GetInteger
'  * @function
'  * @instance
'  * @description Generates random integer value from 1 to specified seed value.
'  * @param {Dynamic} seed - seed value for Rnd function. 
'  * @returns {integer} A random integer value.
'  */ 
Function RBS_IG_GetInteger(seed = 100 as integer) as integer
  return Rnd(seed)
End Function

' /**
'  * @memberof module:ItemGenerator
'  * @name GetFloat
'  * @function
'  * @instance
'  * @description Generates random float value.
'  * @returns {float} A random float value.
'  */ 
Function RBS_IG_GetFloat() as float
  return Rnd(0)
End Function

' /**
'  * @memberof module:ItemGenerator
'  * @name GetString
'  * @function
'  * @instance
'  * @description Generates random string with specified length.
'  * @param {Dynamic} seed - A string length
'  * @returns {string} A random string value or empty string if seed is 0.
'  */ 
Function RBS_IG_GetString(seed as integer) as string
  
  item = ""
  if seed > 0
    stringLength = Rnd(seed)
    
    for i = 0 to stringLength
      chType = Rnd(3)
      
      if chType = 1     'Chr(48-57) - numbers
        chNumber = 47 + Rnd(10)
      else if chType = 2  'Chr(65-90) - Uppercase Letters
        chNumber = 64 + Rnd(26)
      else        'Chr(97-122) - Lowercase Letters
        chNumber = 96 + Rnd(26)
      end if
      
      item = item + Chr(chNumber)
    end for
  end if
  
  return item
End Function

