const null = nothing

mutable struct Node{T}
    el::T
    next::Union{Node{T}, Nothing}
end

mutable struct LinkedList{T}
    head::Union{Node{T}, Nothing}
    tail::Union{Node{T}, Nothing}
end

LinkedList{T}() where {T} = LinkedList{T}(null, null)

function Base.push!(ll::LinkedList{T}, el::T) where {T}
    node = Node{T}(el, null)
    if ll.head == ll.tail == null
        ll.head = ll.tail = node
    else
        ll.tail.next = node
        ll.tail = node
    end
    ll
end

function Base.iterate(ll::LinkedList{T}, node::Union{Node{T}, Nothing}=ll.head) where {T}
    node === null ? null : (node, node.next)
end


function Base.show(io::IO, ll::LinkedList)
    for node in ll
        print(node.el, " -> ")
    end
end

function insertafter!(node::Node{T}, el::T) where {T}
    nextnode = Node{T}(el, node.next)
    node.next = nextnode
    nextnode
end