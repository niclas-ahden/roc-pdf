Semantics :: [].{
	NodeId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> NodeId
		from_index = |idx| NodeId.(idx)

		index : NodeId -> U64
		index = |NodeId.(idx)| idx
	}

	OccurrenceId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> OccurrenceId
		from_index = |idx| OccurrenceId.(idx)

		index : OccurrenceId -> U64
		index = |OccurrenceId.(idx)| idx
	}

	FragmentId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> FragmentId
		from_index = |idx| FragmentId.(idx)

		index : FragmentId -> U64
		index = |FragmentId.(idx)| idx
	}

	NamespaceId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> NamespaceId
		from_index = |idx| NamespaceId.(idx)

		index : NamespaceId -> U64
		index = |NamespaceId.(idx)| idx
	}

	StructureElementId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> StructureElementId
		from_index = |idx| StructureElementId.(idx)

		index : StructureElementId -> U64
		index = |StructureElementId.(idx)| idx
	}

	ElementId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> ElementId
		from_index = |idx| ElementId.(idx)

		index : ElementId -> U64
		index = |ElementId.(idx)| idx
	}

	DestinationId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> DestinationId
		from_index = |idx| DestinationId.(idx)

		index : DestinationId -> U64
		index = |DestinationId.(idx)| idx
	}

	MathMlSubtreeId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> MathMlSubtreeId
		from_index = |idx| MathMlSubtreeId.(idx)

		index : MathMlSubtreeId -> U64
		index = |MathMlSubtreeId.(idx)| idx
	}

	AssertionId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> AssertionId
		from_index = |idx| AssertionId.(idx)

		index : AssertionId -> U64
		index = |AssertionId.(idx)| idx
	}

	AnnotationId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> AnnotationId
		from_index = |idx| AnnotationId.(idx)

		index : AnnotationId -> U64
		index = |AnnotationId.(idx)| idx
	}

	ContextualArtifactId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> ContextualArtifactId
		from_index = |idx| ContextualArtifactId.(idx)

		index : ContextualArtifactId -> U64
		index = |ContextualArtifactId.(idx)| idx
	}

	TextSourceId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> TextSourceId
		from_index = |idx| TextSourceId.(idx)

		index : TextSourceId -> U64
		index = |TextSourceId.(idx)| idx
	}

	TextPropertyId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> TextPropertyId
		from_index = |idx| TextPropertyId.(idx)

		index : TextPropertyId -> U64
		index = |TextPropertyId.(idx)| idx
	}

	NonTextSourceId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> NonTextSourceId
		from_index = |idx| NonTextSourceId.(idx)

		index : NonTextSourceId -> U64
		index = |NonTextSourceId.(idx)| idx
	}

	PageId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> PageId
		from_index = |idx| PageId.(idx)

		index : PageId -> U64
		index = |PageId.(idx)| idx
	}

	ContentStreamId :: U64.{
		is_eq : _
		to_hash : _

		from_index : U64 -> ContentStreamId
		from_index = |idx| ContentStreamId.(idx)

		index : ContentStreamId -> U64
		index = |ContentStreamId.(idx)| idx
	}

	## A contiguous run of `length` indices beginning at `start`, into one of
	## the model's dense buffers (attributes, nodes, glyphs, bytes and so on).
	IndexRange :: { length : U64, start : U64 }.{
		is_eq : _
		to_hash : _

		from_start_and_length : { start : U64, length : U64 } -> IndexRange
		from_start_and_length = |{ start: first, length: count }| IndexRange.{ start: first, length: count }

		length : IndexRange -> U64
		length = |range| range.length

		start : IndexRange -> U64
		start = |range| range.start
	}

	## Namespace objects have identity independent of URI equality.
	Namespace : { id : NamespaceId, kind : NamespaceKind, uri : Str }
	NamespaceKind : [Extension(Str), MathMl, Pdf17, Pdf20]
	Role : { local_name : Str, namespace : NamespaceId }
	RoleMapping : { from : Role, to : Role }

	ElementIdentifier : {
		id : ElementId,
		value : Str,
	}

	NodeParent : [DocumentRoot, ParentNode(NodeId)]

	## One flat buffer stores this mixed order for all nodes. `content` is the
	## exact span belonging to a node and is the source of PDF `/K` order.
	ContentSpineItem : [
		AnnotationOccurrence(AnnotationId),
		ChildNode(NodeId),
		ContentOccurrence(OccurrenceId),
		ContextualArtifact(ContextualArtifactId),
	]

	Node : {
		attributes : IndexRange,
		content : IndexRange,
		element_identifier : [HasElementIdentifier(ElementId), NoElementIdentifier],
		id : NodeId,
		language : Language,
		parent : NodeParent,
		role : Role,
		structure_element : StructureElementId,
		text_properties : IndexRange,
	}

	Language : [Inherited, Language(Str)]

	TextRange : {
		scalars : IndexRange,
		utf8_bytes : IndexRange,
	}
	SourceRange : [ByteRange(IndexRange), UnicodeRange(TextRange)]

	OccurrenceSource : [
		NonText(NonTextSourceId, SourceRange),
		Text(TextSourceId, SourceRange),
	]

	ContentOccurrence : {
		fragments : IndexRange,
		id : OccurrenceId,
		language : Language,
		source : OccurrenceSource,
		text_properties : IndexRange,
	}

	## Source Unicode is owned exactly once in this dense store.
	TextSource : { unicode : Str }

	TextProperty : [
		ActualText(Str),
		AlternativeText(Str),
		ExpandedText(Str),
		Phoneme(Str),
		PhoneticAlphabet(Str),
		ReplacementText(Str),
		SourceToPresentation(
			{
				kind : PresentationTransformation,
				presentation : Str,
				source : TextRange,
			},
		),
	]

	PresentationTransformation : [
		BidirectionalReordering,
		CaseMapping,
		GeneratedText,
		InsertedDiscretionaryHyphen,
		SelectedSoftHyphen,
		Ligature,
		SuppressedSoftHyphen,
	]

	AttributeOwner : [Artifact, Layout, List, Namespace(NamespaceId), Table]
	AttributeName : [
		Namespaced({ local_name : Str, namespace : NamespaceId }),
		Standard(Str),
	]
	RoleFamily : [ArtifactRoles, BlockRoles, InlineRoles, ListRoles, TableRoles]
	AttributeApplicability : [AllRoles, ExactRoles(IndexRange), Family(RoleFamily)]
	AttributeValue : [Integer(I64), Name(Str), Names(List(Str)), Text(Str)]
	StructureAttribute : {
		applicability : AttributeApplicability,
		name : AttributeName,
		owner : AttributeOwner,
		value : AttributeValue,
	}

	ContextualArtifact : {
		attributes : IndexRange,
		id : ContextualArtifactId,
		parent : NodeId,
	}

	Annotation : {
		id : AnnotationId,
		logical_order : U64,
		owner : NodeId,
	}

	Relationship : [
		AnnotationFor({ annotation : AnnotationId, owner : ElementId }),
		CaptionFor({ caption : NodeId, target : NodeId }),
		DestinationTarget({ destination : DestinationId, target : ElementId }),
		HeaderFor({ cell : ElementId, header : ElementId }),
		LabelFor({ label : NodeId, target : NodeId }),
		NoteFor({ note : NodeId, target : NodeId }),
		ReferenceTo({ source : ElementId, target : ElementId }),
	]

	MathMlValidationWork : {
		attribute_visits : U64,
		node_visits : U64,
		utf8_bytes : U64,
	}
	MathMlOrigin : [
		Typed,
		ValidatedParse({ source : NonTextSourceId, work : MathMlValidationWork }),
	]

	## The subtree references already-normalized semantic nodes. No unchecked
	## markup string crosses this boundary or becomes an associated file.
	MathMlSubtree : {
		id : MathMlSubtreeId,
		namespace : NamespaceId,
		nodes : IndexRange,
		origin : MathMlOrigin,
		root : NodeId,
	}

	AuthorAssertionKind : [
		AlternativeTextMeaningful,
		ReadingOrderMeaningful,
		TableHeadersMeaningful,
	]
	AuthorAssertion : {
		id : AssertionId,
		kind : AuthorAssertionKind,
		node : NodeId,
	}

	LayoutFragment : {
		content_stream : ContentStreamId,
		continuation_index : U64,
		id : FragmentId,
		occurrence : OccurrenceId,
		page : PageId,
		source_range : SourceRange,
	}

	## Fixed-shape records and variable data are kept in separate dense buffers.
	## `occurrence_fragments` is the counts/prefix-sum reverse index; fragments
	## themselves are never duplicated.
	Store : {
		annotations : List(Annotation),
		assertions : List(AuthorAssertion),
		attribute_roles : List(Role),
		attributes : List(StructureAttribute),
		content_spine : List(ContentSpineItem),
		contextual_artifacts : List(ContextualArtifact),
		document_root : NodeId,
		fragments : List(LayoutFragment),
		element_identifiers : List(ElementIdentifier),
		mathml_subtrees : List(MathMlSubtree),
		namespaces : List(Namespace),
		nodes : List(Node),
		non_text_sources : List(List(U8)),
		occurrence_fragments : List(FragmentId),
		occurrences : List(ContentOccurrence),
		relationships : List(Relationship),
		role_mappings : List(RoleMapping),
		text_properties : List(TextProperty),
		text_sources : List(TextSource),
	}
}

# Semantic node IDs preserve their dense index.
expect Semantics.NodeId.from_index(7).index() == 7

# Content occurrence IDs preserve their dense index.
expect Semantics.OccurrenceId.from_index(11).index() == 11

# Layout fragment IDs preserve their dense index.
expect Semantics.FragmentId.from_index(13).index() == 13

# Emitted structure-element IDs remain independent of semantic node IDs.
expect Semantics.StructureElementId.from_index(19).index() == 19

# IDTree element identities preserve their dense index.
expect Semantics.ElementId.from_index(23).index() == 23

# Ranges preserve their exact start offset.
expect Semantics.IndexRange.from_start_and_length({ start: 5, length: 8 }).start() == 5

# Ranges preserve their exact length.
expect Semantics.IndexRange.from_start_and_length({ start: 5, length: 8 }).length() == 8

# Nested public type modules construct opaque node IDs directly.
expect Semantics.NodeId.from_index(17).index() == 17

# Nested public type modules construct exact ranges directly.
expect Semantics.IndexRange.from_start_and_length({ start: 2, length: 3 }).length() == 3
