# Note For Homework2

## Review for the Week3 course

> 个人感觉第二次作业对应的内容确实还比较多，所以需要在完成作业之前回顾一下之前学习的内容。

首先介绍的是编程语言的compound type。这里介绍了任何编程语言都会提供的构建compound type的三种类型。

> "Each-of": A compound type t describes values that contain each of values of type t1, t2, ..., and tn.
>
> “One-of”: A compound type t describes values that contain a value of one of the types t1, t2, ..., or tn.
>
> “Self-reference”: A compound type t may refer to itself in its definition in order to describe recursive data structures like lists and trees.

比如说我们之前一直使用的C语言中的结构体，就属于Each-of的结构体，因为描述该结构体需要每一个字段一起来描述，类似的有Tuple，Java的class。

One-of type类型的 compound type在我自己之前学习的语言中其实使用不多，sml中的 int option是一个例子。它表示一个值要么是int，要么是NONE。

Self-reference让type可以递归地描述数据结构。

---

Record 类型是一种 Each-of 类型，个人感觉和C语言中的结构体非常类似。

声明方法

```sml
{
	foo:int,
	bar:int*bool,
	baz:bool*int
}
访问其中字段的方法是：#foo；比如说
val e = {bar=5,foo=(5,true)};
#foo e;
```

本质上tuple也是一种Record，只是tuple的每一个字段名都是数字。所以其实tuple是Record的一种语法糖。

---

Datatype Binding 可以用来创建我们自己的One-of type

```sml
datatype mytype = TwoInts of int*int
								| Str of string
								| Pizza
```

其中 TwonInts，Str，Pizza是三种构造函数

访问datatype创造的我们自己的compound type可以使用case expression（感觉是这一个week的course最重要的东西）。

```
fun f x = 
		case x of
				Pizza => 3
				TwoInts(i1,i2)=>i1+i2
				Str s=> String.size
```

其中的每一个branch的形式都是 pattern => expression，这种case-expression叫做pattern-matching。

---

type synonyms 用来创造现有存在的type的另一个名称，这两个名称是完全等价，完全可以替换的。比如说

```
type foo = int
```

那么foo和int是完全等价的。

---

List 和 Option都是 Datatype

比如说自己定义自己的List

```
datatype my_int_list = Empty
											| Cons of int * my_int_list
fun append_mylist(xs, ys)=
	case xs of
			Empty => ys
		| Cons(x,xs') = Cons(x, append_mylist(xs'))
```

需要注意的是一般其他的语言是不允许变量名中出现' 符号的，但是ML语言是可以的，读的话就是“xx prime”

---

Polymorphic Datatypes 多态数据类型

多态的概念是为不同的数据类型提供统一的接口。 比如说sml中的list，我们可以声明任意数据类型的list，例如int list, (int * bool) list

```
datatype 'a option = NONE | SOME of 'a
```

这一句表示的并不是创建一个新的type，而是说如果'a的类型是t，那么就会有t type

比如下面声明的这个datatype

```
datatype('a,'b) tree = Node of 'a * ('a,'b) tree * ('a,'b')tree
										 | Leaf of 'b
```

我们可以用上述的datatype生成 (int, int) tree 或者 (string, int) tree

---

Pattern-matching for Each-of Types

之前说的case expression也可以用在Each-of tupe中。例如

```
fun sum_triple(triple:int*int*int) = 
 case triple of 
 		(x,y,z) => x + y + z
(*one branch 的 case expression看起来比较奇怪，所以我们可以简化*)
func sum_triple(triple:int*int*int) = 
	let val(x,y,z) = triple
	in 
		x + y + z
	end
	
(* 类型可以通过编译器自动推断出来*)
fun sum_triple(x,y,z) = 
	x + y + z
```

神奇的发现到最后就变成了一个一般意义上的多变量函数。

事实上在ML中，所有的函数都只有一个argument。当我们在写ML中的多argument函数的时候，事实上只有一个argumenet。每一次我们写多argument的function实际上是将一个tuple作为函数的argument，然后进行pattern-matching。

类似的，其实zero-argument的函数也是不存在的。其实是使用的uni-pattern 去匹配传入的uint value()

---

嵌套的模式

粗略地来说，模式匹配的语义是被匹配到的值必须要有和pattern相同的shape，而变量被绑定到right pieces。

比如说

a::(b::(c::d))匹配的是一个至少有3个元素的list。

a::(b::(c::[]))匹配的是只含有3个元素的list。

(a,b,c) :: d 表示的是至少具有1个元素的triple list

我们可以使用nested pattern，党我们想要匹配一些值具有特定的shape的时候，

```
fun len xs = 
	case xs of
		[]=>0
	| x::xs' => 1 + len xs'
```

因为我们并没有实际使用到变量x，所以一种更合适的风格是

```
fun len xs = 
	case xs of
		[]=>0
	| _::xs' => 1 + len xs'
```

_ 匹配的是任意value，并且不会引入新的binding

---

模式的嵌套是很有用的，比如说该函数可以用来判断一个int list是否是排序的

```
fun nondecreasing intlist =
    case intlist of
        [] => true
      | _::[] => true
      | head::(neck::rest) => (head <= neck andalso nondecreasing (neck::rest))
```

---

ML可以允许我们自己定义异常，并且捕获异常

```
(*异常的定义*)
exception MyUndesirableCondition
exception MyOtherException of int*int

(*在函数中使用异常*)
fun maxlist (xs,ex) = (* int list * exn -> int *)
    case xs of
        [] => raise ex
      | x::[] => x
      | x::xs' => Int.max(x,maxlist(xs',ex))

(*捕获异常的方法*)
val z = maxlist ([],MyUndesirableCondition) (* 42 *)
	handle MyUndesirableCondition => 42

```

---

Tail Recursion and Accumulators

使用尾递归可以提高递归的效率（主要是从函数调用栈的角度上来说）

使用尾递归的话函数调用栈不需要存储递归的中间expression

```
fun rev1 lst =
   case lst of
       [] => []
     | x::xs => (rev1 xs) @ [x]



fun rev2 lst =
    let fun aux(lst,acc) =
            case lst of
                [] => acc
              | x::xs => aux(xs, x::acc)
    in
        aux(lst,[])
		end
```



---

## Hints and Gotchas for Homework 2

## Hints and Gotchas for Homework 2

Contributed by Charilaos Skiadas

### Notes on the material 

- Three key ways of creating "compound" types, make sure to understand them 
- Tuples are just records 
- Datatype bindings are used to create one-of types: extremely powerful and flexible (for example can build trees) 
- A datatype binding creates functions (or constants) for each of the constructors. 
- Note the keyword datatypedatatype is not used when writing values of that type. 
- Type synonyms offer alternative names for complicated types (e.g., type date = int*int*int) 
- Pattern matching rocks! Enough said. 
- Using val p = eval p = e where pp is a pattern (like (x,y,z)(x,y,z) or { x= x, y = y }{ x= x, y = y }) can be a very effective way to get values out of a tuple or record. 
- Lists and options are really just datatypes (worth understanding how that works). Practice by creating your own "list" type. 
- Nested patterns can be very expressive. 
- Pay attention to the use of the wildcard __ for parts of a pattern we don't care to name. 
- Raising/handling exceptions is similar to datatypes and pattern-matching. 
- Appending to the end of a list is relatively expensive. 
