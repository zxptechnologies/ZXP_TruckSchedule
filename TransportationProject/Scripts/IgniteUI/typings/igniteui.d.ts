
interface DataSourceSettingsPaging {
	enabled?: boolean;
	type?: any;
	pageSize?: number;
	pageSizeUrlKey?: string;
	pageIndexUrlKey?: string;
	pageIndex?: number;
	appendPage?: boolean;
}

interface DataSourceSettingsFiltering {
	type?: any;
	caseSensitive?: boolean;
	applyToAllData?: boolean;
	customFunc?: any;
	filterExprUrlKey?: string;
	filterLogicUrlKey?: string;
	defaultFields?: any[];
	expressions?: any[];
	exprString?: string;
}

interface DataSourceSettingsSorting {
	defaultDirection?: any;
	defaultFields?: any[];
	applyToAllData?: boolean;
	customFunc?: any;
	compareFunc?: any;
	customConvertFunc?: any;
	type?: any;
	caseSensitive?: boolean;
	sortUrlKey?: string;
	sortUrlAscValueKey?: string;
	sortUrlDescValueKey?: string;
	expressions?: any[];
	exprString?: string;
}

interface DataSourceSettingsSummaries {
	type?: any;
	summaryExprUrlKey?: string;
	summariesResponseKey?: string;
	summaryExecution?: any;
	columnSettings?: any[];
}

interface DataSourceSettings {
	id?: string;
	outputResultsName?: string;
	callback?: Function;
	callee?: any;
	data?: any[];
	dataSource?: any;
	dataBinding?: any;
	dataBound?: any;
	requestType?: string;
	type?: any;
	schema?: any;
	primaryKey?: string;
	responseTotalRecCountKey?: string;
	responseDataKey?: string;
	responseDataType?: any;
	responseContentType?: string;
	localSchemaTransform?: boolean;
	urlParamsEncoding?: any;
	urlParamsEncoded?: any;
	paging?: DataSourceSettingsPaging;
	filtering?: DataSourceSettingsFiltering;
	sorting?: DataSourceSettingsSorting;
	summaries?: DataSourceSettingsSummaries;
	fields?: any[];
	serializeTransactionLog?: boolean;
	aggregateTransactions?: boolean;
	autoCommit?: boolean;
	updateUrl?: string;
	rowAdded?: Function;
	rowUpdated?: Function;
	rowInserted?: Function;
	rowDeleted?: Function;
}

declare module Infragistics {
export class DataSource  {
	constructor(settings: DataSourceSettings);
}
}
interface IgniteUIStatic {
DataSource(settings: DataSourceSettings): void;
}

declare module Infragistics {
export class TypeParser  {
}
}

interface DataSchemaSchema {
	fields?: any[];
	searchField?: string;
	outputResultsName?: string;
}

declare module Infragistics {
export class DataSchema  {
	constructor(schema: DataSchemaSchema);
}
}
interface IgniteUIStatic {
DataSchema(schema: DataSchemaSchema): void;
}

declare module Infragistics {
export class RemoteDataSource extends DataSource {
	constructor(settings: DataSourceSettings);
}
}
interface IgniteUIStatic {
RemoteDataSource(settings: DataSourceSettings): void;
}

declare module Infragistics {
export class JSONDataSource extends DataSource {
	constructor(settings: DataSourceSettings);
}
}
interface IgniteUIStatic {
JSONDataSource(settings: DataSourceSettings): void;
}

interface RESTDataSourceSettingsRestSettingsCreate {
	url?: string;
	template?: string;
	batch?: boolean;
}

interface RESTDataSourceSettingsRestSettingsUpdate {
	url?: string;
	template?: string;
	batch?: boolean;
}

interface RESTDataSourceSettingsRestSettingsRemove {
	url?: string;
	template?: string;
	batch?: boolean;
}

interface RESTDataSourceSettingsRestSettings {
	create?: RESTDataSourceSettingsRestSettingsCreate;
	update?: RESTDataSourceSettingsRestSettingsUpdate;
	remove?: RESTDataSourceSettingsRestSettingsRemove;
	encodeRemoveInRequestUri?: boolean;
	contentSerializer?: Function;
	contentType?: string;
}

interface RESTDataSourceSettings {
	restSettings?: RESTDataSourceSettingsRestSettings;
}

declare module Infragistics {
export class RESTDataSource extends DataSource {
	constructor(settings: RESTDataSourceSettings);
	constructor(settings: DataSourceSettings);
}
}
interface IgniteUIStatic {
RESTDataSource(settings: DataSourceSettings): void;
}

interface JSONPDataSourceSettings {
	jsonp?: any;
	jsonpCallback?: any;
}

declare module Infragistics {
export class JSONPDataSource extends DataSource {
	constructor(settings: JSONPDataSourceSettings);
	constructor(settings: DataSourceSettings);
}
}
interface IgniteUIStatic {
JSONPDataSource(settings: DataSourceSettings): void;
}

declare module Infragistics {
export class XmlDataSource extends DataSource {
	constructor(settings: DataSourceSettings);
}
}
interface IgniteUIStatic {
XmlDataSource(settings: DataSourceSettings): void;
}

declare module Infragistics {
export class FunctionDataSource extends DataSource {
	constructor(settings: DataSourceSettings);
}
}
interface IgniteUIStatic {
FunctionDataSource(settings: DataSourceSettings): void;
}

declare module Infragistics {
export class HtmlTableDataSource extends DataSource {
	constructor(settings: DataSourceSettings);
}
}
interface IgniteUIStatic {
HtmlTableDataSource(settings: DataSourceSettings): void;
}

declare module Infragistics {
export class ArrayDataSource extends DataSource {
	constructor(settings: DataSourceSettings);
}
}
interface IgniteUIStatic {
ArrayDataSource(settings: DataSourceSettings): void;
}

interface MashupDataSourceMashupSettings {
	ignorePartialRecords?: boolean;
	dataSource?: any[];
}

declare module Infragistics {
export class MashupDataSource extends DataSource {
	constructor(mashupSettings: MashupDataSourceMashupSettings);
	constructor(settings: DataSourceSettings);
}
}
interface IgniteUIStatic {
MashupDataSource(settings: DataSourceSettings): void;
}

interface HierarchicalDataSourceSettingsPaging {
}

interface HierarchicalDataSourceSettingsSorting {
}

interface HierarchicalDataSourceSettingsFiltering {
}

interface HierarchicalDataSourceSettings {
	autogenerate?: boolean;
	initialDataBindDepth?: number;
	maxDataBindDepth?: number;
	defaultChildrenDataProperty?: string;
	callback?: any;
	callee?: any;
	data?: any[];
	dataSource?: any;
	dataBinding?: any;
	dataBound?: any;
	type?: string;
	responseDataType?: any;
	responseContentType?: any;
	localSchemaTransform?: boolean;
	urlParamsEncoding?: any;
	urlParamsEncoded?: any;
	requestType?: string;
	odata?: boolean;
	paging?: HierarchicalDataSourceSettingsPaging;
	sorting?: HierarchicalDataSourceSettingsSorting;
	filtering?: HierarchicalDataSourceSettingsFiltering;
	schema?: any[];
}

declare module Infragistics {
export class HierarchicalDataSource  {
	constructor(settings: HierarchicalDataSourceSettings);
}
}
interface IgniteUIStatic {
HierarchicalDataSource(settings: HierarchicalDataSourceSettings): void;
}

interface TreeHierarchicalDataSourceSettingsTreeDSFiltering {
	fromLevel?: number;
	toLevel?: number;
	displayMode?: any;
	matchFiltering?: string;
}

interface TreeHierarchicalDataSourceSettingsTreeDSSorting {
	fromLevel?: number;
	toLevel?: number;
}

interface TreeHierarchicalDataSourceSettingsTreeDSPaging {
	mode?: any;
}

interface TreeHierarchicalDataSourceSettingsTreeDS {
	childDataKey?: string;
	foreignKey?: string;
	initialExpandDepth?: number;
	enableRemoteLoadOnDemand?: boolean;
	dataSourceUrl?: string;
	requestDataOnToggle?: boolean;
	requestDataCallback?: Function;
	requestDataSuccessCallback?: Function;
	requestDataErrorCallback?: Function;
	propertyExpanded?: string;
	propertyDataLevel?: string;
	filtering?: TreeHierarchicalDataSourceSettingsTreeDSFiltering;
	sorting?: TreeHierarchicalDataSourceSettingsTreeDSSorting;
	paging?: TreeHierarchicalDataSourceSettingsTreeDSPaging;
}

interface TreeHierarchicalDataSourceSettings {
	treeDS?: TreeHierarchicalDataSourceSettingsTreeDS;
}

declare module Infragistics {
export class TreeHierarchicalDataSource extends DataSource {
	constructor(settings: TreeHierarchicalDataSourceSettings);
	constructor(settings: DataSourceSettings);
}
}
interface IgniteUIStatic {
TreeHierarchicalDataSource(settings: DataSourceSettings): void;
}

declare module Infragistics {
export class DvCommonWidget  {
}
}

interface SimpleTextMarkerTemplateSettings {
	padding?: number;
	getText?: any;
	backgroundColor?: string;
	borderColor?: string;
	borderThickness?: number;
	textColor?: string;
	font?: any;
}

declare module Infragistics {
export class SimpleTextMarkerTemplate  {
	constructor(requireThis: boolean);
	constructor(settings: SimpleTextMarkerTemplateSettings);
}
}
interface IgniteUIStatic {
SimpleTextMarkerTemplate(settings: SimpleTextMarkerTemplateSettings): void;
}

interface OlapXmlaDataSourceOptionsRequestOptions {
	withCredentials?: boolean;
	beforeSend?: Function;
}

interface OlapXmlaDataSourceOptionsMdxSettings {
	nonEmptyOnRows?: boolean;
	nonEmptyOnColumns?: boolean;
	addCalculatedMembersOnRows?: boolean;
	addCalculatedMembersOnColumns?: boolean;
	dimensionPropertiesOnRows?: any[];
	dimensionPropertiesOnColumns?: any[];
}

interface OlapXmlaDataSourceOptions {
	serverUrl?: string;
	catalog?: string;
	cube?: string;
	measureGroup?: string;
	measures?: string;
	filters?: string;
	rows?: string;
	columns?: string;
	requestOptions?: OlapXmlaDataSourceOptionsRequestOptions;
	enableResultCache?: boolean;
	discoverProperties?: any;
	executeProperties?: any;
	mdxSettings?: OlapXmlaDataSourceOptionsMdxSettings;
}

declare module Infragistics {
export class OlapXmlaDataSource  {
	constructor(options: OlapXmlaDataSourceOptions);
}
}
interface IgniteUIStatic {
OlapXmlaDataSource(options: OlapXmlaDataSourceOptions): void;
}

interface OlapFlatDataSourceOptionsMetadataCubeMeasuresDimensionMeasure {
	name?: string;
	caption?: string;
	aggregator?: Function;
	displayFolder?: string;
}

interface OlapFlatDataSourceOptionsMetadataCubeMeasuresDimension {
	name?: string;
	caption?: string;
	measures?: OlapFlatDataSourceOptionsMetadataCubeMeasuresDimensionMeasure[];
}

interface OlapFlatDataSourceOptionsMetadataCubeDimensionHierarchieLevel {
	name?: string;
	caption?: string;
	memberProvider?: Function;
}

interface OlapFlatDataSourceOptionsMetadataCubeDimensionHierarchie {
	name?: string;
	caption?: string;
	displayFolder?: string;
	levels?: OlapFlatDataSourceOptionsMetadataCubeDimensionHierarchieLevel[];
}

interface OlapFlatDataSourceOptionsMetadataCubeDimension {
	name?: string;
	caption?: string;
	hierarchies?: OlapFlatDataSourceOptionsMetadataCubeDimensionHierarchie[];
}

interface OlapFlatDataSourceOptionsMetadataCube {
	name?: string;
	caption?: string;
	measuresDimension?: OlapFlatDataSourceOptionsMetadataCubeMeasuresDimension;
	dimensions?: OlapFlatDataSourceOptionsMetadataCubeDimension[];
}

interface OlapFlatDataSourceOptionsMetadata {
	cube?: OlapFlatDataSourceOptionsMetadataCube;
}

interface OlapFlatDataSourceOptions {
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	responseDataType?: string;
	measures?: string;
	filters?: string;
	rows?: string;
	columns?: string;
	metadata?: OlapFlatDataSourceOptionsMetadata;
}

declare module Infragistics {
export class OlapFlatDataSource  {
	constructor(options: OlapFlatDataSourceOptions);
}
}
interface IgniteUIStatic {
OlapFlatDataSource(options: OlapFlatDataSourceOptions): void;
}

declare module Infragistics {
export class OlapMetadataTreeItem  {
}
}

interface OlapResultViewOptions {
	result?: any;
	visibleResult?: any;
	hasColumns?: boolean;
	hasRows?: boolean;
}

declare module Infragistics {
export class OlapResultView  {
	constructor(options: OlapResultViewOptions);
}
}
interface IgniteUIStatic {
OlapResultView(options: OlapResultViewOptions): void;
}

interface OlapTableViewOptionsViewSettings {
	isParentInFrontForColumns?: boolean;
	isParentInFrontForRows?: boolean;
	compactColumnHeaders?: boolean;
	compactRowHeaders?: boolean;
}

interface OlapTableViewOptions {
	result?: any;
	hasColumns?: boolean;
	hasRows?: boolean;
	viewSettings?: OlapTableViewOptionsViewSettings;
}

declare module Infragistics {
export class OlapTableView  {
	constructor(options: OlapTableViewOptions);
}
}
interface IgniteUIStatic {
OlapTableView(options: OlapTableViewOptions): void;
}

declare module Infragistics {
export class OlapTableViewHeaderCell  {
}
}

declare module Infragistics {
export class OlapTableViewResultCell  {
}
}

declare module Infragistics {
export class Catalog  {
}
}

declare module Infragistics {
export class Cube  {
}
}

declare module Infragistics {
export class Dimension  {
}
}

declare module Infragistics {
export class Hierarchy  {
}
}

declare module Infragistics {
export class Measure  {
}
}

declare module Infragistics {
export class Level  {
}
}

declare module Infragistics {
export class MeasureGroup  {
}
}

declare module Infragistics {
export class MeasureList  {
}
}

declare module Infragistics {
export class OlapResult  {
}
}

interface OlapResultAxisOptions {
	tuples?: any[];
	tupleSize?: number;
}

declare module Infragistics {
export class OlapResultAxis  {
	constructor(options: OlapResultAxisOptions);
}
}
interface IgniteUIStatic {
OlapResultAxis(options: OlapResultAxisOptions): void;
}

interface OlapResultTupleOptions {
	members?: any[];
}

declare module Infragistics {
export class OlapResultTuple  {
	constructor(options: OlapResultTupleOptions);
}
}
interface IgniteUIStatic {
OlapResultTuple(options: OlapResultTupleOptions): void;
}

declare module Infragistics {
export class OlapResultAxisMember  {
}
}

declare module Infragistics {
export class OlapResultCell  {
}
}

interface IgTemplatingRegExp {
}

declare module Infragistics {
export class igTemplating  {
	constructor(regExp: IgTemplatingRegExp);
}
}
interface IgniteUIStatic {
igTemplating(regExp: IgTemplatingRegExp): void;
}

interface ErrorMessageDisplayingEvent {
	(event: Event, ui: ErrorMessageDisplayingEventUIParam): void;
}

interface ErrorMessageDisplayingEventUIParam {
	owner?: any;
	errorMessage?: any;
}

interface DataChangedEvent {
	(event: Event, ui: DataChangedEventUIParam): void;
}

interface DataChangedEventUIParam {
	owner?: any;
	newData?: any;
}

interface IgQRCodeBarcode {
	width?: any;
	height?: any;
	backingBrush?: string;
	backingOutline?: string;
	backingStrokeThickness?: number;
	barBrush?: string;
	fontBrush?: string;
	font?: string;
	data?: string;
	errorMessageText?: string;
	stretch?: any;
	barsFillMode?: any;
	widthToHeightRatio?: number;
	xDimension?: number;
	errorCorrectionLevel?: any;
	sizeVersion?: any;
	encodingMode?: any;
	eciNumber?: number;
	eciHeaderDisplayMode?: any;
	fnc1Mode?: any;
	applicationIndicator?: string;
	errorMessageDisplaying?: ErrorMessageDisplayingEvent;
	dataChanged?: DataChangedEvent;
}
interface IgQRCodeBarcodeMethods {
	exportVisualData(): Object;
	flush(): void;
	destroy(): void;
	styleUpdated(): void;
}
interface JQuery {
	data(propertyName: "igQRCodeBarcode"):IgQRCodeBarcodeMethods;
}

interface JQuery {
	igQRCodeBarcode(methodName: "exportVisualData"): Object;
	igQRCodeBarcode(methodName: "flush"): void;
	igQRCodeBarcode(methodName: "destroy"): void;
	igQRCodeBarcode(methodName: "styleUpdated"): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "width"): any;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "height"): any;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "backingBrush"): string;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "backingBrush", optionValue: string): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "backingOutline"): string;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "backingOutline", optionValue: string): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "backingStrokeThickness"): number;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "backingStrokeThickness", optionValue: number): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "barBrush"): string;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "barBrush", optionValue: string): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "fontBrush"): string;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "fontBrush", optionValue: string): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "font"): string;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "font", optionValue: string): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "data"): string;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "data", optionValue: string): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "errorMessageText"): string;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "errorMessageText", optionValue: string): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "stretch"): any;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "stretch", optionValue: any): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "barsFillMode"): any;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "barsFillMode", optionValue: any): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "widthToHeightRatio"): number;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "widthToHeightRatio", optionValue: number): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "xDimension"): number;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "xDimension", optionValue: number): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "errorCorrectionLevel"): any;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "errorCorrectionLevel", optionValue: any): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "sizeVersion"): any;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "sizeVersion", optionValue: any): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "encodingMode"): any;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "encodingMode", optionValue: any): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "eciNumber"): number;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "eciNumber", optionValue: number): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "eciHeaderDisplayMode"): any;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "eciHeaderDisplayMode", optionValue: any): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "fnc1Mode"): any;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "fnc1Mode", optionValue: any): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "applicationIndicator"): string;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "applicationIndicator", optionValue: string): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "errorMessageDisplaying"): ErrorMessageDisplayingEvent;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "errorMessageDisplaying", optionValue: ErrorMessageDisplayingEvent): void;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "dataChanged"): DataChangedEvent;
	igQRCodeBarcode(optionLiteral: 'option', optionName: "dataChanged", optionValue: DataChangedEvent): void;
	igQRCodeBarcode(options: IgQRCodeBarcode): JQuery;
	igQRCodeBarcode(optionLiteral: 'option', optionName: string): any;
	igQRCodeBarcode(optionLiteral: 'option', options: IgQRCodeBarcode): JQuery;
	igQRCodeBarcode(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igQRCodeBarcode(methodName: string, ...methodParams: any[]): any;
}
interface DataBindingEvent {
	(event: Event, ui: DataBindingEventUIParam): void;
}

interface DataBindingEventUIParam {
	owner?: any;
	dataSource?: any;
}

interface DataBoundEvent {
	(event: Event, ui: DataBoundEventUIParam): void;
}

interface DataBoundEventUIParam {
	owner?: any;
	data?: any;
	dataSource?: any;
}

interface UpdateTooltipEvent {
	(event: Event, ui: UpdateTooltipEventUIParam): void;
}

interface UpdateTooltipEventUIParam {
	owner?: any;
	text?: any;
	item?: any;
	x?: any;
	y?: any;
	element?: any;
}

interface HideTooltipEvent {
	(event: Event, ui: HideTooltipEventUIParam): void;
}

interface HideTooltipEventUIParam {
	owner?: any;
	item?: any;
	element?: any;
}

interface IgBaseChart {
	width?: number;
	height?: number;
	tooltipTemplate?: string;
	maxRecCount?: number;
	dataSource?: any;
	dataSourceType?: string;
	dataSourceUrl?: string;
	responseTotalRecCountKey?: string;
	responseDataKey?: string;
	dataBinding?: DataBindingEvent;
	dataBound?: DataBoundEvent;
	updateTooltip?: UpdateTooltipEvent;
	hideTooltip?: HideTooltipEvent;
}
interface IgBaseChartMethods {
	findIndexOfItem(item: Object): number;
	getDataItem(index: Object): Object;
	getData(): any[];
	addItem(item: Object): Object;
	insertItem(item: Object, index: number): Object;
	removeItem(index: number): Object;
	setItem(index: number, item: Object): Object;
	notifySetItem(dataSource: Object, index: number, newItem: Object, oldItem: Object): Object;
	notifyClearItems(dataSource: Object): Object;
	notifyInsertItem(dataSource: Object, index: number, newItem: Object): Object;
	notifyRemoveItem(dataSource: Object, index: number, oldItem: Object): Object;
	chart(): Object;
	dataBind(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igBaseChart"):IgBaseChartMethods;
}

interface JQuery {
	igBaseChart(methodName: "findIndexOfItem", item: Object): number;
	igBaseChart(methodName: "getDataItem", index: Object): Object;
	igBaseChart(methodName: "getData"): any[];
	igBaseChart(methodName: "addItem", item: Object): Object;
	igBaseChart(methodName: "insertItem", item: Object, index: number): Object;
	igBaseChart(methodName: "removeItem", index: number): Object;
	igBaseChart(methodName: "setItem", index: number, item: Object): Object;
	igBaseChart(methodName: "notifySetItem", dataSource: Object, index: number, newItem: Object, oldItem: Object): Object;
	igBaseChart(methodName: "notifyClearItems", dataSource: Object): Object;
	igBaseChart(methodName: "notifyInsertItem", dataSource: Object, index: number, newItem: Object): Object;
	igBaseChart(methodName: "notifyRemoveItem", dataSource: Object, index: number, oldItem: Object): Object;
	igBaseChart(methodName: "chart"): Object;
	igBaseChart(methodName: "dataBind"): void;
	igBaseChart(methodName: "destroy"): void;
	igBaseChart(optionLiteral: 'option', optionName: "width"): number;
	igBaseChart(optionLiteral: 'option', optionName: "width", optionValue: number): void;
	igBaseChart(optionLiteral: 'option', optionName: "height"): number;
	igBaseChart(optionLiteral: 'option', optionName: "height", optionValue: number): void;
	igBaseChart(optionLiteral: 'option', optionName: "tooltipTemplate"): string;
	igBaseChart(optionLiteral: 'option', optionName: "tooltipTemplate", optionValue: string): void;
	igBaseChart(optionLiteral: 'option', optionName: "maxRecCount"): number;
	igBaseChart(optionLiteral: 'option', optionName: "maxRecCount", optionValue: number): void;
	igBaseChart(optionLiteral: 'option', optionName: "dataSource"): any;
	igBaseChart(optionLiteral: 'option', optionName: "dataSource", optionValue: any): void;
	igBaseChart(optionLiteral: 'option', optionName: "dataSourceType"): string;
	igBaseChart(optionLiteral: 'option', optionName: "dataSourceType", optionValue: string): void;
	igBaseChart(optionLiteral: 'option', optionName: "dataSourceUrl"): string;
	igBaseChart(optionLiteral: 'option', optionName: "dataSourceUrl", optionValue: string): void;
	igBaseChart(optionLiteral: 'option', optionName: "responseTotalRecCountKey"): string;
	igBaseChart(optionLiteral: 'option', optionName: "responseTotalRecCountKey", optionValue: string): void;
	igBaseChart(optionLiteral: 'option', optionName: "responseDataKey"): string;
	igBaseChart(optionLiteral: 'option', optionName: "responseDataKey", optionValue: string): void;
	igBaseChart(optionLiteral: 'option', optionName: "dataBinding"): DataBindingEvent;
	igBaseChart(optionLiteral: 'option', optionName: "dataBinding", optionValue: DataBindingEvent): void;
	igBaseChart(optionLiteral: 'option', optionName: "dataBound"): DataBoundEvent;
	igBaseChart(optionLiteral: 'option', optionName: "dataBound", optionValue: DataBoundEvent): void;
	igBaseChart(optionLiteral: 'option', optionName: "updateTooltip"): UpdateTooltipEvent;
	igBaseChart(optionLiteral: 'option', optionName: "updateTooltip", optionValue: UpdateTooltipEvent): void;
	igBaseChart(optionLiteral: 'option', optionName: "hideTooltip"): HideTooltipEvent;
	igBaseChart(optionLiteral: 'option', optionName: "hideTooltip", optionValue: HideTooltipEvent): void;
	igBaseChart(options: IgBaseChart): JQuery;
	igBaseChart(optionLiteral: 'option', optionName: string): any;
	igBaseChart(optionLiteral: 'option', options: IgBaseChart): JQuery;
	igBaseChart(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igBaseChart(methodName: string, ...methodParams: any[]): any;
}
interface IgBulletGraphRange {
	name?: string;
	brush?: string;
	outline?: string;
	startValue?: number;
	endValue?: number;
	innerStartExtent?: number;
	innerEndExtent?: number;
	outerStartExtent?: number;
	outerEndExtent?: number;
	strokeThickness?: number;
}

interface FormatLabelEvent {
	(event: Event, ui: FormatLabelEventUIParam): void;
}

interface FormatLabelEventUIParam {
}

interface AlignLabelEvent {
	(event: Event, ui: AlignLabelEventUIParam): void;
}

interface AlignLabelEventUIParam {
}

interface IgBulletGraph {
	width?: any;
	height?: any;
	ranges?: IgBulletGraphRange[];
	rangeToolTipTemplate?: string;
	valueToolTipTemplate?: string;
	targetValueToolTipTemplate?: string;
	orientation?: any;
	rangeBrushes?: any;
	rangeOutlines?: any;
	minimumValue?: number;
	maximumValue?: number;
	targetValue?: number;
	targetValueName?: string;
	value?: number;
	valueName?: string;
	rangeInnerExtent?: number;
	rangeOuterExtent?: number;
	valueInnerExtent?: number;
	valueOuterExtent?: number;
	interval?: number;
	ticksPostInitial?: number;
	ticksPreTerminal?: number;
	labelInterval?: number;
	labelExtent?: number;
	labelsPostInitial?: number;
	labelsPreTerminal?: number;
	minorTickCount?: number;
	tickStartExtent?: number;
	tickEndExtent?: number;
	tickStrokeThickness?: number;
	tickBrush?: string;
	fontBrush?: string;
	valueBrush?: string;
	valueOutline?: string;
	valueStrokeThickness?: number;
	minorTickStartExtent?: number;
	minorTickEndExtent?: number;
	minorTickStrokeThickness?: number;
	minorTickBrush?: string;
	isScaleInverted?: boolean;
	backingBrush?: string;
	backingOutline?: string;
	backingStrokeThickness?: number;
	backingInnerExtent?: number;
	backingOuterExtent?: number;
	scaleStartExtent?: number;
	scaleEndExtent?: number;
	targetValueBrush?: string;
	targetValueBreadth?: number;
	targetValueInnerExtent?: number;
	targetValueOuterExtent?: number;
	targetValueOutline?: string;
	targetValueStrokeThickness?: number;
	transitionDuration?: number;
	showToolTipTimeout?: number;
	showToolTip?: boolean;
	font?: string;
	formatLabel?: FormatLabelEvent;
	alignLabel?: AlignLabelEvent;
}
interface IgBulletGraphMethods {
	getRangeNames(): void;
	addRange(value: Object): void;
	removeRange(value: Object): void;
	updateRange(value: Object): void;
	exportVisualData(): Object;
	flush(): void;
	destroy(): void;
	styleUpdated(): void;
}
interface JQuery {
	data(propertyName: "igBulletGraph"):IgBulletGraphMethods;
}

interface JQuery {
	igBulletGraph(methodName: "getRangeNames"): void;
	igBulletGraph(methodName: "addRange", value: Object): void;
	igBulletGraph(methodName: "removeRange", value: Object): void;
	igBulletGraph(methodName: "updateRange", value: Object): void;
	igBulletGraph(methodName: "exportVisualData"): Object;
	igBulletGraph(methodName: "flush"): void;
	igBulletGraph(methodName: "destroy"): void;
	igBulletGraph(methodName: "styleUpdated"): void;
	igBulletGraph(optionLiteral: 'option', optionName: "width"): any;
	igBulletGraph(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igBulletGraph(optionLiteral: 'option', optionName: "height"): any;
	igBulletGraph(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igBulletGraph(optionLiteral: 'option', optionName: "ranges"): IgBulletGraphRange[];
	igBulletGraph(optionLiteral: 'option', optionName: "ranges", optionValue: IgBulletGraphRange[]): void;
	igBulletGraph(optionLiteral: 'option', optionName: "rangeToolTipTemplate"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "rangeToolTipTemplate", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "valueToolTipTemplate"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "valueToolTipTemplate", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueToolTipTemplate"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueToolTipTemplate", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "orientation"): any;
	igBulletGraph(optionLiteral: 'option', optionName: "orientation", optionValue: any): void;
	igBulletGraph(optionLiteral: 'option', optionName: "rangeBrushes"): any;
	igBulletGraph(optionLiteral: 'option', optionName: "rangeBrushes", optionValue: any): void;
	igBulletGraph(optionLiteral: 'option', optionName: "rangeOutlines"): any;
	igBulletGraph(optionLiteral: 'option', optionName: "rangeOutlines", optionValue: any): void;
	igBulletGraph(optionLiteral: 'option', optionName: "minimumValue"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "minimumValue", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "maximumValue"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "maximumValue", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValue"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValue", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueName"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueName", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "value"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "value", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "valueName"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "valueName", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "rangeInnerExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "rangeInnerExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "rangeOuterExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "rangeOuterExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "valueInnerExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "valueInnerExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "valueOuterExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "valueOuterExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "interval"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "interval", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "ticksPostInitial"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "ticksPostInitial", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "ticksPreTerminal"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "ticksPreTerminal", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "labelInterval"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "labelInterval", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "labelExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "labelExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "labelsPostInitial"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "labelsPostInitial", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "labelsPreTerminal"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "labelsPreTerminal", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "minorTickCount"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "minorTickCount", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "tickStartExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "tickStartExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "tickEndExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "tickEndExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "tickStrokeThickness"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "tickStrokeThickness", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "tickBrush"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "tickBrush", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "fontBrush"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "fontBrush", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "valueBrush"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "valueBrush", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "valueOutline"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "valueOutline", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "valueStrokeThickness"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "valueStrokeThickness", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "minorTickStartExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "minorTickStartExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "minorTickEndExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "minorTickEndExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "minorTickStrokeThickness"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "minorTickStrokeThickness", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "minorTickBrush"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "minorTickBrush", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "isScaleInverted"): boolean;
	igBulletGraph(optionLiteral: 'option', optionName: "isScaleInverted", optionValue: boolean): void;
	igBulletGraph(optionLiteral: 'option', optionName: "backingBrush"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "backingBrush", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "backingOutline"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "backingOutline", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "backingStrokeThickness"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "backingStrokeThickness", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "backingInnerExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "backingInnerExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "backingOuterExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "backingOuterExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "scaleStartExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "scaleStartExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "scaleEndExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "scaleEndExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueBrush"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueBrush", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueBreadth"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueBreadth", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueInnerExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueInnerExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueOuterExtent"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueOuterExtent", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueOutline"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueOutline", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueStrokeThickness"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "targetValueStrokeThickness", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "transitionDuration"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "transitionDuration", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "showToolTipTimeout"): number;
	igBulletGraph(optionLiteral: 'option', optionName: "showToolTipTimeout", optionValue: number): void;
	igBulletGraph(optionLiteral: 'option', optionName: "showToolTip"): boolean;
	igBulletGraph(optionLiteral: 'option', optionName: "showToolTip", optionValue: boolean): void;
	igBulletGraph(optionLiteral: 'option', optionName: "font"): string;
	igBulletGraph(optionLiteral: 'option', optionName: "font", optionValue: string): void;
	igBulletGraph(optionLiteral: 'option', optionName: "formatLabel"): FormatLabelEvent;
	igBulletGraph(optionLiteral: 'option', optionName: "formatLabel", optionValue: FormatLabelEvent): void;
	igBulletGraph(optionLiteral: 'option', optionName: "alignLabel"): AlignLabelEvent;
	igBulletGraph(optionLiteral: 'option', optionName: "alignLabel", optionValue: AlignLabelEvent): void;
	igBulletGraph(options: IgBulletGraph): JQuery;
	igBulletGraph(optionLiteral: 'option', optionName: string): any;
	igBulletGraph(optionLiteral: 'option', options: IgBulletGraph): JQuery;
	igBulletGraph(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igBulletGraph(methodName: string, ...methodParams: any[]): any;
}
interface IgDataChartCrosshairPoint {
	x?: number;
	y?: number;
}

interface IgDataChartLegend {
	element?: string;
	type?: any;
	width?: any;
	height?: any;
}

interface IgDataChartAxes {
	type?: any;
	name?: string;
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	remove?: boolean;
	labelLocation?: any;
	labelVisibility?: any;
	labelExtent?: number;
	labelAngle?: number;
	labelTextStyle?: string;
	labelTextColor?: string;
	formatLabel?: any;
	stroke?: string;
	strokeThickness?: number;
	strip?: string;
	majorStroke?: string;
	majorStrokeThickness?: number;
	minorStroke?: string;
	minorStrokeThickness?: number;
	isInverted?: boolean;
	crossingAxis?: string;
	crossingValue?: any;
	coercionMethods?: any;
	label?: any;
	gap?: number;
	overlap?: number;
	startAngleOffset?: number;
	interval?: number;
	displayType?: any;
	minimumValue?: number;
	maximumValue?: number;
	dateTimeMemberPath?: string;
	referenceValue?: number;
	isLogarithmic?: boolean;
	logarithmBase?: number;
	radiusExtentScale?: number;
	innerRadiusExtentScale?: number;
	title?: string;
	titleTextStyle?: string;
	titleMargin?: number;
	titleHorizontalAlignment?: any;
	titleVerticalAlignment?: any;
	titlePosition?: any;
	titleTopMargin?: number;
	titleLeftMargin?: number;
	titleRightMargin?: number;
	titleBottomMargin?: number;
	labelHorizontalAlignment?: any;
	labelVerticalAlignment?: any;
	labelMargin?: number;
	labelTopMargin?: number;
	labelLeftMargin?: number;
	labelRightMargin?: number;
	labelBottomMargin?: number;
	showFirstLabel?: boolean;
	titleAngle?: number;
	tickLength?: number;
	tickStrokeThickness?: number;
	tickStroke?: any;
	useClusteringMode?: boolean;
}

interface IgDataChartSeriesLegend {
	element?: string;
	type?: any;
	width?: any;
	height?: any;
}

interface IgDataChartSeries {
	type?: any;
	name?: string;
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	remove?: boolean;
	showTooltip?: boolean;
	tooltipTemplate?: string;
	legend?: IgDataChartSeriesLegend;
	legendItemVisibility?: any;
	legendItemBadgeTemplate?: any;
	legendItemTemplate?: any;
	discreteLegendItemTemplate?: any;
	transitionDuration?: number;
	transitionEasingFunction?: any;
	resolution?: number;
	title?: string;
	brush?: string;
	outline?: string;
	thickness?: number;
	coercionMethods?: any;
	markerType?: any;
	markerTemplate?: any;
	markerBrush?: string;
	markerOutline?: string;
	xAxis?: string;
	yAxis?: string;
	xMemberPath?: string;
	yMemberPath?: string;
	trendLineType?: any;
	trendLineBrush?: string;
	trendLineThickness?: number;
	trendLinePeriod?: number;
	trendLineZIndex?: number;
	maximumMarkers?: number;
	unknownValuePlotting?: any;
	radiusMemberPath?: string;
	radiusScale?: any;
	labelMemberPath?: string;
	fillMemberPath?: string;
	fillScale?: any;
	angleAxis?: string;
	valueAxis?: string;
	clipSeriesToBounds?: boolean;
	valueMemberPath?: string;
	radiusX?: number;
	radiusY?: number;
	angleMemberPath?: number;
	radiusAxis?: string;
	useCartesianInterpolation?: boolean;
	negativeBrush?: string;
	splineType?: any;
	lowMemberPath?: string;
	highMemberPath?: string;
	openMemberPath?: string;
	closeMemberPath?: string;
	volumeMemberPath?: string;
	displayType?: any;
	ignoreFirst?: number;
	period?: number;
	shortPeriod?: number;
	longPeriod?: number;
	markerCollisionAvoidance?: any;
	useHighMarkerFidelity?: boolean;
	useBruteForce?: boolean;
	progressiveLoad?: boolean;
	mouseOverEnabled?: boolean;
	useSquareCutoffStyle?: boolean;
	heatMinimum?: number;
	heatMaximum?: number;
	heatMinimumColor?: any;
	heatMaximumColor?: any;
	series?: any[];
	isDropShadowEnabled?: boolean;
	useSingleShadow?: boolean;
	shadowColor?: any;
	shadowBlur?: number;
	shadowOffsetX?: number;
	shadowOffsetY?: number;
	isTransitionInEnabled?: boolean;
	transitionInSpeedType?: any;
	transitionInMode?: any;
	transitionInDuration?: number;
	radius?: number;
	areaFillOpacity?: number;
	expectFunctions?: boolean;
	useInterpolation?: boolean;
	skipUnknownValues?: boolean;
	verticalLineVisibility?: boolean;
	horizontalLineVisibility?: boolean;
	targetSeries?: string;
	targetAxis?: string;
	isCustomCategoryStyleAllowed?: boolean;
	isCustomCategoryMarkerStyleAllowed?: boolean;
	isHighlightingEnabled?: boolean;
	bandHighlightWidth?: number;
	highlightType?: any;
	tooltipPosition?: any;
	cursorPosition?: any;
	isDefaultCrosshairDisabled?: boolean;
	useIndex?: boolean;
	useLegend?: boolean;
}

interface TooltipShowingEvent {
	(event: Event, ui: TooltipShowingEventUIParam): void;
}

interface TooltipShowingEventUIParam {
	element?: any;
	item?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
}

interface TooltipShownEvent {
	(event: Event, ui: TooltipShownEventUIParam): void;
}

interface TooltipShownEventUIParam {
	element?: any;
	item?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
}

interface TooltipHidingEvent {
	(event: Event, ui: TooltipHidingEventUIParam): void;
}

interface TooltipHidingEventUIParam {
	element?: any;
	item?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
}

interface TooltipHiddenEvent {
	(event: Event, ui: TooltipHiddenEventUIParam): void;
}

interface TooltipHiddenEventUIParam {
	element?: any;
	item?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
}

interface BrowserNotSupportedEvent {
	(event: Event, ui: BrowserNotSupportedEventUIParam): void;
}

interface BrowserNotSupportedEventUIParam {
}

interface SeriesCursorMouseMoveEvent {
	(event: Event, ui: SeriesCursorMouseMoveEventUIParam): void;
}

interface SeriesCursorMouseMoveEventUIParam {
	item?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
	positionX?: any;
	positionY?: any;
}

interface SeriesMouseLeftButtonDownEvent {
	(event: Event, ui: SeriesMouseLeftButtonDownEventUIParam): void;
}

interface SeriesMouseLeftButtonDownEventUIParam {
	item?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
	positionX?: any;
	positionY?: any;
}

interface SeriesMouseLeftButtonUpEvent {
	(event: Event, ui: SeriesMouseLeftButtonUpEventUIParam): void;
}

interface SeriesMouseLeftButtonUpEventUIParam {
	item?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
	positionX?: any;
	positionY?: any;
}

interface SeriesMouseMoveEvent {
	(event: Event, ui: SeriesMouseMoveEventUIParam): void;
}

interface SeriesMouseMoveEventUIParam {
	item?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
	positionX?: any;
	positionY?: any;
}

interface SeriesMouseEnterEvent {
	(event: Event, ui: SeriesMouseEnterEventUIParam): void;
}

interface SeriesMouseEnterEventUIParam {
	item?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
	positionX?: any;
	positionY?: any;
}

interface SeriesMouseLeaveEvent {
	(event: Event, ui: SeriesMouseLeaveEventUIParam): void;
}

interface SeriesMouseLeaveEventUIParam {
	item?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
	positionX?: any;
	positionY?: any;
}

interface WindowRectChangedEvent {
	(event: Event, ui: WindowRectChangedEventUIParam): void;
}

interface WindowRectChangedEventUIParam {
	chart?: any;
	newHeight?: any;
	newLeft?: any;
	newTop?: any;
	newWidth?: any;
	oldHeight?: any;
	oldLeft?: any;
	oldTop?: any;
	oldWidth?: any;
}

interface GridAreaRectChangedEvent {
	(event: Event, ui: GridAreaRectChangedEventUIParam): void;
}

interface GridAreaRectChangedEventUIParam {
	chart?: any;
	newHeight?: any;
	newLeft?: any;
	newTop?: any;
	newWidth?: any;
	oldHeight?: any;
	oldLeft?: any;
	oldTop?: any;
	oldWidth?: any;
}

interface RefreshCompletedEvent {
	(event: Event, ui: RefreshCompletedEventUIParam): void;
}

interface RefreshCompletedEventUIParam {
	chart?: any;
}

interface AxisRangeChangedEvent {
	(event: Event, ui: AxisRangeChangedEventUIParam): void;
}

interface AxisRangeChangedEventUIParam {
	axis?: any;
	chart?: any;
	newMaximumValue?: any;
	newMinimumValue?: any;
	oldMaximumValue?: any;
	oldMinimumValue?: any;
}

interface TypicalBasedOnEvent {
	(event: Event, ui: TypicalBasedOnEventUIParam): void;
}

interface TypicalBasedOnEventUIParam {
	chart?: any;
	series?: any;
	count?: any;
	position?: any;
	supportingCalculations?: any;
	dataSource?: any;
	basedOn?: any;
}

interface ProgressiveLoadStatusChangedEvent {
	(event: Event, ui: ProgressiveLoadStatusChangedEventUIParam): void;
}

interface ProgressiveLoadStatusChangedEventUIParam {
	chart?: any;
	series?: any;
	currentStatus?: any;
}

interface AssigningCategoryStyleEvent {
	(event: Event, ui: AssigningCategoryStyleEventUIParam): void;
}

interface AssigningCategoryStyleEventUIParam {
	chart?: any;
	series?: any;
	startIndex?: any;
	endIndex?: any;
	hasDateRange?: any;
	startDate?: any;
	endDate?: any;
	getItems?: any;
	fill?: any;
	stroke?: any;
	opacity?: any;
	highlightingHandled?: any;
	maxAllSeriesHighlightingProgress?: any;
	sumAllSeriesHighlightingProgress?: any;
}

interface AssigningCategoryMarkerStyleEvent {
	(event: Event, ui: AssigningCategoryMarkerStyleEventUIParam): void;
}

interface AssigningCategoryMarkerStyleEventUIParam {
	chart?: any;
	series?: any;
	startIndex?: any;
	endIndex?: any;
	hasDateRange?: any;
	startDate?: any;
	endDate?: any;
	getItems?: any;
	fill?: any;
	stroke?: any;
	opacity?: any;
	highlightingHandled?: any;
	maxAllSeriesHighlightingProgress?: any;
	sumAllSeriesHighlightingProgress?: any;
}

interface IgDataChart {
	syncChannel?: string;
	synchronizeVertically?: boolean;
	syncrhonizeHorizontally?: boolean;
	crosshairPoint?: IgDataChartCrosshairPoint;
	windowRect?: any;
	horizontalZoomable?: boolean;
	verticalZoomable?: boolean;
	windowResponse?: any;
	windowRectMinWidth?: number;
	overviewPlusDetailPaneVisibility?: any;
	crosshairVisibility?: any;
	plotAreaBackground?: string;
	defaultInteraction?: any;
	dragModifier?: any;
	panModifier?: any;
	previewRect?: any;
	windowPositionHorizontal?: number;
	windowPositionVertical?: number;
	windowScaleHorizontal?: number;
	windowScaleVertical?: number;
	circleMarkerTemplate?: any;
	triangleMarkerTemplate?: any;
	pyramidMarkerTemplate?: any;
	squareMarkerTemplate?: any;
	diamondMarkerTemplate?: any;
	pentagonMarkerTemplate?: any;
	hexagonMarkerTemplate?: any;
	tetragramMarkerTemplate?: any;
	pentagramMarkerTemplate?: any;
	hexagramMarkerTemplate?: any;
	topMargin?: number;
	leftMargin?: number;
	rightMargin?: number;
	bottomMargin?: number;
	autoMarginWidth?: number;
	autoMarginHeight?: number;
	isSquare?: boolean;
	gridMode?: any;
	brushes?: any;
	markerBrushes?: any;
	outlines?: any;
	markerOutlines?: any;
	width?: any;
	height?: any;
	size?: any;
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	isSurfaceInteractionDisabled?: boolean;
	animateSeriesWhenAxisRangeChanges?: boolean;
	title?: string;
	subtitle?: string;
	titleTextStyle?: string;
	titleTopMargin?: number;
	titleLeftMargin?: number;
	titleRightMargin?: number;
	titleBottomMargin?: number;
	subtitleTextStyle?: string;
	subtitleTopMargin?: number;
	subtitleLeftMargin?: number;
	subtitleRightMargin?: number;
	subtitleBottomMargin?: number;
	titleTextColor?: any;
	subtitleTextColor?: any;
	titleHorizontalAlignment?: any;
	subtitleHorizontalAlignment?: any;
	highlightingTransitionDuration?: number;
	useTiledZooming?: boolean;
	preferHigherResolutionTiles?: boolean;
	zoomTileCacheSize?: number;
	legend?: IgDataChartLegend;
	axes?: IgDataChartAxes[];
	series?: IgDataChartSeries[];
	theme?: string;
	tooltipShowing?: TooltipShowingEvent;
	tooltipShown?: TooltipShownEvent;
	tooltipHiding?: TooltipHidingEvent;
	tooltipHidden?: TooltipHiddenEvent;
	browserNotSupported?: BrowserNotSupportedEvent;
	seriesCursorMouseMove?: SeriesCursorMouseMoveEvent;
	seriesMouseLeftButtonDown?: SeriesMouseLeftButtonDownEvent;
	seriesMouseLeftButtonUp?: SeriesMouseLeftButtonUpEvent;
	seriesMouseMove?: SeriesMouseMoveEvent;
	seriesMouseEnter?: SeriesMouseEnterEvent;
	seriesMouseLeave?: SeriesMouseLeaveEvent;
	windowRectChanged?: WindowRectChangedEvent;
	gridAreaRectChanged?: GridAreaRectChangedEvent;
	refreshCompleted?: RefreshCompletedEvent;
	axisRangeChanged?: AxisRangeChangedEvent;
	typicalBasedOn?: TypicalBasedOnEvent;
	progressiveLoadStatusChanged?: ProgressiveLoadStatusChangedEvent;
	assigningCategoryStyle?: AssigningCategoryStyleEvent;
	assigningCategoryMarkerStyle?: AssigningCategoryMarkerStyleEvent;
}
interface IgDataChartMethods {
	option(): void;
	widget(): void;
	id(): string;
	exportImage(width?: Object, height?: Object): Object;
	destroy(): void;
	styleUpdated(): Object;
	resetZoom(): Object;
	addItem(item: Object, targetName: string): void;
	insertItem(item: Object, index: number, targetName: string): void;
	removeItem(index: number, targetName: string): void;
	setItem(index: number, item: Object, targetName: string): void;
	notifySetItem(dataSource: Object, index: number, newItem: Object, oldItem: Object): Object;
	notifyClearItems(dataSource: Object): Object;
	notifyInsertItem(dataSource: Object, index: number, newItem: Object): Object;
	notifyRemoveItem(dataSource: Object, index: number, oldItem: Object): Object;
	scrollIntoView(targetName: string, item: Object): Object;
	scaleValue(targetName: string, unscaledValue: number): number;
	unscaleValue(targetName: string, scaledValue: number): number;
	notifyVisualPropertiesChanged(targetName: string): Object;
	flush(): void;
	exportVisualData(): void;
	getActualMinimumValue(targetName: string): void;
	getActualMaximumValue(targetName: string): void;
	print(): void;
	renderSeries(targetName: string, animate: boolean): void;
	getItemIndex(targetName: string, worldPoint: Object): number;
	getItem(targetName: string, worldPoint: Object): Object;
	getItemSpan(targetName: string): number;
	getSeriesValue(targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	getSeriesValuePosition(targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	getSeriesValuePositionFromSeriesPixel(targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	getSeriesValueFromSeriesPixel(targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	getSeriesHighValue(targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	getSeriesHighValuePosition(targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	getSeriesHighValuePositionFromSeriesPixel(targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	getSeriesHighValueFromSeriesPixel(targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	getSeriesLowValue(targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	getSeriesLowValuePosition(targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	getSeriesLowValuePositionFromSeriesPixel(targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	getSeriesLowValueFromSeriesPixel(targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	getItemIndexFromSeriesPixel(targetName: string, seriesPoint: Object): number;
	getItemFromSeriesPixel(targetName: string, seriesPoint: Object): Object;
	getSeriesOffsetValue(targetName: string): number;
	getSeriesCategoryWidth(targetName: string): number;
	replayTransitionIn(targetName: string): Object;
	simulateHover(targetName: string, seriesPoint: Object): Object;
	moveCursorPoint(targetName: string, worldPoint: Object): Object;
	startTiledZoomingIfNecessary(): void;
	endTiledZoomingIfRunning(): void;
	clearTileZoomCache(): void;
}
interface JQuery {
	data(propertyName: "igDataChart"):IgDataChartMethods;
}

interface IgPieChartLegend {
	element?: string;
	type?: any;
	width?: number;
	height?: number;
}

interface SliceClickEvent {
	(event: Event, ui: SliceClickEventUIParam): void;
}

interface SliceClickEventUIParam {
	chart?: any;
	slice?: any;
}

interface IgPieChart {
	width?: any;
	height?: any;
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	valueMemberPath?: string;
	labelMemberPath?: string;
	labelsPosition?: any;
	leaderLineVisibility?: any;
	leaderLineType?: any;
	leaderLineMargin?: number;
	othersCategoryThreshold?: number;
	formatLabel?: Function;
	othersCategoryStyle?: any;
	othersCategoryType?: any;
	othersCategoryText?: string;
	explodedRadius?: number;
	radiusFactor?: number;
	allowSliceSelection?: boolean;
	allowSliceExplosion?: boolean;
	explodedSlices?: any[];
	showTooltip?: boolean;
	tooltipTemplate?: string;
	legend?: IgPieChartLegend;
	labelExtent?: number;
	startAngle?: number;
	sweepDirection?: any;
	selectedStyle?: any;
	brushes?: any;
	outlines?: any;
	legendItemTemplate?: any;
	legendItemBadgeTemplate?: any;
	textStyle?: string;
	theme?: string;
	tooltipShowing?: TooltipShowingEvent;
	tooltipShown?: TooltipShownEvent;
	tooltipHiding?: TooltipHidingEvent;
	tooltipHidden?: TooltipHiddenEvent;
	browserNotSupported?: BrowserNotSupportedEvent;
	sliceClick?: SliceClickEvent;
}
interface IgPieChartMethods {
	option(): void;
	addItem(item: Object): void;
	insertItem(item: Object, index: number): void;
	removeItem(index: number): void;
	setItem(index: number, item: Object): void;
	exportImage(width?: Object, height?: Object): Object;
	destroy(): void;
	id(): string;
	widget(): void;
	print(): void;
	exportVisualData(): void;
}
interface JQuery {
	data(propertyName: "igPieChart"):IgPieChartMethods;
}

interface JQuery {
	igDataChart(methodName: "option"): void;
	igDataChart(methodName: "widget"): void;
	igDataChart(methodName: "id"): string;
	igDataChart(methodName: "exportImage", width?: Object, height?: Object): Object;
	igDataChart(methodName: "destroy"): void;
	igDataChart(methodName: "styleUpdated"): Object;
	igDataChart(methodName: "resetZoom"): Object;
	igDataChart(methodName: "addItem", item: Object, targetName: string): void;
	igDataChart(methodName: "insertItem", item: Object, index: number, targetName: string): void;
	igDataChart(methodName: "removeItem", index: number, targetName: string): void;
	igDataChart(methodName: "setItem", index: number, item: Object, targetName: string): void;
	igDataChart(methodName: "notifySetItem", dataSource: Object, index: number, newItem: Object, oldItem: Object): Object;
	igDataChart(methodName: "notifyClearItems", dataSource: Object): Object;
	igDataChart(methodName: "notifyInsertItem", dataSource: Object, index: number, newItem: Object): Object;
	igDataChart(methodName: "notifyRemoveItem", dataSource: Object, index: number, oldItem: Object): Object;
	igDataChart(methodName: "scrollIntoView", targetName: string, item: Object): Object;
	igDataChart(methodName: "scaleValue", targetName: string, unscaledValue: number): number;
	igDataChart(methodName: "unscaleValue", targetName: string, scaledValue: number): number;
	igDataChart(methodName: "notifyVisualPropertiesChanged", targetName: string): Object;
	igDataChart(methodName: "flush"): void;
	igDataChart(methodName: "exportVisualData"): void;
	igDataChart(methodName: "getActualMinimumValue", targetName: string): void;
	igDataChart(methodName: "getActualMaximumValue", targetName: string): void;
	igDataChart(methodName: "print"): void;
	igDataChart(methodName: "renderSeries", targetName: string, animate: boolean): void;
	igDataChart(methodName: "getItemIndex", targetName: string, worldPoint: Object): number;
	igDataChart(methodName: "getItem", targetName: string, worldPoint: Object): Object;
	igDataChart(methodName: "getItemSpan", targetName: string): number;
	igDataChart(methodName: "getSeriesValue", targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	igDataChart(methodName: "getSeriesValuePosition", targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	igDataChart(methodName: "getSeriesValuePositionFromSeriesPixel", targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	igDataChart(methodName: "getSeriesValueFromSeriesPixel", targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	igDataChart(methodName: "getSeriesHighValue", targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	igDataChart(methodName: "getSeriesHighValuePosition", targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	igDataChart(methodName: "getSeriesHighValuePositionFromSeriesPixel", targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	igDataChart(methodName: "getSeriesHighValueFromSeriesPixel", targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	igDataChart(methodName: "getSeriesLowValue", targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	igDataChart(methodName: "getSeriesLowValuePosition", targetName: string, worldPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	igDataChart(methodName: "getSeriesLowValuePositionFromSeriesPixel", targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): Object;
	igDataChart(methodName: "getSeriesLowValueFromSeriesPixel", targetName: string, seriesPoint: Object, useInterpolation: boolean, skipUnknowns: boolean): number;
	igDataChart(methodName: "getItemIndexFromSeriesPixel", targetName: string, seriesPoint: Object): number;
	igDataChart(methodName: "getItemFromSeriesPixel", targetName: string, seriesPoint: Object): Object;
	igDataChart(methodName: "getSeriesOffsetValue", targetName: string): number;
	igDataChart(methodName: "getSeriesCategoryWidth", targetName: string): number;
	igDataChart(methodName: "replayTransitionIn", targetName: string): Object;
	igDataChart(methodName: "simulateHover", targetName: string, seriesPoint: Object): Object;
	igDataChart(methodName: "moveCursorPoint", targetName: string, worldPoint: Object): Object;
	igDataChart(methodName: "startTiledZoomingIfNecessary"): void;
	igDataChart(methodName: "endTiledZoomingIfRunning"): void;
	igDataChart(methodName: "clearTileZoomCache"): void;
	igDataChart(optionLiteral: 'option', optionName: "syncChannel"): string;
	igDataChart(optionLiteral: 'option', optionName: "syncChannel", optionValue: string): void;
	igDataChart(optionLiteral: 'option', optionName: "synchronizeVertically"): boolean;
	igDataChart(optionLiteral: 'option', optionName: "synchronizeVertically", optionValue: boolean): void;
	igDataChart(optionLiteral: 'option', optionName: "syncrhonizeHorizontally"): boolean;
	igDataChart(optionLiteral: 'option', optionName: "syncrhonizeHorizontally", optionValue: boolean): void;
	igDataChart(optionLiteral: 'option', optionName: "crosshairPoint"): IgDataChartCrosshairPoint;
	igDataChart(optionLiteral: 'option', optionName: "crosshairPoint", optionValue: IgDataChartCrosshairPoint): void;
	igDataChart(optionLiteral: 'option', optionName: "windowRect"): any;
	igDataChart(optionLiteral: 'option', optionName: "windowRect", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "horizontalZoomable"): boolean;
	igDataChart(optionLiteral: 'option', optionName: "horizontalZoomable", optionValue: boolean): void;
	igDataChart(optionLiteral: 'option', optionName: "verticalZoomable"): boolean;
	igDataChart(optionLiteral: 'option', optionName: "verticalZoomable", optionValue: boolean): void;
	igDataChart(optionLiteral: 'option', optionName: "windowResponse"): any;
	igDataChart(optionLiteral: 'option', optionName: "windowResponse", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "windowRectMinWidth"): number;
	igDataChart(optionLiteral: 'option', optionName: "windowRectMinWidth", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "overviewPlusDetailPaneVisibility"): any;
	igDataChart(optionLiteral: 'option', optionName: "overviewPlusDetailPaneVisibility", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "crosshairVisibility"): any;
	igDataChart(optionLiteral: 'option', optionName: "crosshairVisibility", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "plotAreaBackground"): string;
	igDataChart(optionLiteral: 'option', optionName: "plotAreaBackground", optionValue: string): void;
	igDataChart(optionLiteral: 'option', optionName: "defaultInteraction"): any;
	igDataChart(optionLiteral: 'option', optionName: "defaultInteraction", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "dragModifier"): any;
	igDataChart(optionLiteral: 'option', optionName: "dragModifier", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "panModifier"): any;
	igDataChart(optionLiteral: 'option', optionName: "panModifier", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "previewRect"): any;
	igDataChart(optionLiteral: 'option', optionName: "previewRect", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "windowPositionHorizontal"): number;
	igDataChart(optionLiteral: 'option', optionName: "windowPositionHorizontal", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "windowPositionVertical"): number;
	igDataChart(optionLiteral: 'option', optionName: "windowPositionVertical", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "windowScaleHorizontal"): number;
	igDataChart(optionLiteral: 'option', optionName: "windowScaleHorizontal", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "windowScaleVertical"): number;
	igDataChart(optionLiteral: 'option', optionName: "windowScaleVertical", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "circleMarkerTemplate"): any;
	igDataChart(optionLiteral: 'option', optionName: "circleMarkerTemplate", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "triangleMarkerTemplate"): any;
	igDataChart(optionLiteral: 'option', optionName: "triangleMarkerTemplate", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "pyramidMarkerTemplate"): any;
	igDataChart(optionLiteral: 'option', optionName: "pyramidMarkerTemplate", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "squareMarkerTemplate"): any;
	igDataChart(optionLiteral: 'option', optionName: "squareMarkerTemplate", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "diamondMarkerTemplate"): any;
	igDataChart(optionLiteral: 'option', optionName: "diamondMarkerTemplate", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "pentagonMarkerTemplate"): any;
	igDataChart(optionLiteral: 'option', optionName: "pentagonMarkerTemplate", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "hexagonMarkerTemplate"): any;
	igDataChart(optionLiteral: 'option', optionName: "hexagonMarkerTemplate", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "tetragramMarkerTemplate"): any;
	igDataChart(optionLiteral: 'option', optionName: "tetragramMarkerTemplate", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "pentagramMarkerTemplate"): any;
	igDataChart(optionLiteral: 'option', optionName: "pentagramMarkerTemplate", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "hexagramMarkerTemplate"): any;
	igDataChart(optionLiteral: 'option', optionName: "hexagramMarkerTemplate", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "topMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "topMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "leftMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "leftMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "rightMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "rightMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "bottomMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "bottomMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "autoMarginWidth"): number;
	igDataChart(optionLiteral: 'option', optionName: "autoMarginWidth", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "autoMarginHeight"): number;
	igDataChart(optionLiteral: 'option', optionName: "autoMarginHeight", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "isSquare"): boolean;
	igDataChart(optionLiteral: 'option', optionName: "isSquare", optionValue: boolean): void;
	igDataChart(optionLiteral: 'option', optionName: "gridMode"): any;
	igDataChart(optionLiteral: 'option', optionName: "gridMode", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "brushes"): any;
	igDataChart(optionLiteral: 'option', optionName: "brushes", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "markerBrushes"): any;
	igDataChart(optionLiteral: 'option', optionName: "markerBrushes", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "outlines"): any;
	igDataChart(optionLiteral: 'option', optionName: "outlines", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "markerOutlines"): any;
	igDataChart(optionLiteral: 'option', optionName: "markerOutlines", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "width"): any;
	igDataChart(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "height"): any;
	igDataChart(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "size"): any;
	igDataChart(optionLiteral: 'option', optionName: "size", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "dataSource"): any;
	igDataChart(optionLiteral: 'option', optionName: "dataSource", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "dataSourceUrl"): string;
	igDataChart(optionLiteral: 'option', optionName: "dataSourceUrl", optionValue: string): void;
	igDataChart(optionLiteral: 'option', optionName: "dataSourceType"): string;
	igDataChart(optionLiteral: 'option', optionName: "dataSourceType", optionValue: string): void;
	igDataChart(optionLiteral: 'option', optionName: "responseDataKey"): string;
	igDataChart(optionLiteral: 'option', optionName: "responseDataKey", optionValue: string): void;
	igDataChart(optionLiteral: 'option', optionName: "isSurfaceInteractionDisabled"): boolean;
	igDataChart(optionLiteral: 'option', optionName: "isSurfaceInteractionDisabled", optionValue: boolean): void;
	igDataChart(optionLiteral: 'option', optionName: "animateSeriesWhenAxisRangeChanges"): boolean;
	igDataChart(optionLiteral: 'option', optionName: "animateSeriesWhenAxisRangeChanges", optionValue: boolean): void;
	igDataChart(optionLiteral: 'option', optionName: "title"): string;
	igDataChart(optionLiteral: 'option', optionName: "title", optionValue: string): void;
	igDataChart(optionLiteral: 'option', optionName: "subtitle"): string;
	igDataChart(optionLiteral: 'option', optionName: "subtitle", optionValue: string): void;
	igDataChart(optionLiteral: 'option', optionName: "titleTextStyle"): string;
	igDataChart(optionLiteral: 'option', optionName: "titleTextStyle", optionValue: string): void;
	igDataChart(optionLiteral: 'option', optionName: "titleTopMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "titleTopMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "titleLeftMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "titleLeftMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "titleRightMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "titleRightMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "titleBottomMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "titleBottomMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "subtitleTextStyle"): string;
	igDataChart(optionLiteral: 'option', optionName: "subtitleTextStyle", optionValue: string): void;
	igDataChart(optionLiteral: 'option', optionName: "subtitleTopMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "subtitleTopMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "subtitleLeftMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "subtitleLeftMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "subtitleRightMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "subtitleRightMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "subtitleBottomMargin"): number;
	igDataChart(optionLiteral: 'option', optionName: "subtitleBottomMargin", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "titleTextColor"): any;
	igDataChart(optionLiteral: 'option', optionName: "titleTextColor", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "subtitleTextColor"): any;
	igDataChart(optionLiteral: 'option', optionName: "subtitleTextColor", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "titleHorizontalAlignment"): any;
	igDataChart(optionLiteral: 'option', optionName: "titleHorizontalAlignment", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "subtitleHorizontalAlignment"): any;
	igDataChart(optionLiteral: 'option', optionName: "subtitleHorizontalAlignment", optionValue: any): void;
	igDataChart(optionLiteral: 'option', optionName: "highlightingTransitionDuration"): number;
	igDataChart(optionLiteral: 'option', optionName: "highlightingTransitionDuration", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "useTiledZooming"): boolean;
	igDataChart(optionLiteral: 'option', optionName: "useTiledZooming", optionValue: boolean): void;
	igDataChart(optionLiteral: 'option', optionName: "preferHigherResolutionTiles"): boolean;
	igDataChart(optionLiteral: 'option', optionName: "preferHigherResolutionTiles", optionValue: boolean): void;
	igDataChart(optionLiteral: 'option', optionName: "zoomTileCacheSize"): number;
	igDataChart(optionLiteral: 'option', optionName: "zoomTileCacheSize", optionValue: number): void;
	igDataChart(optionLiteral: 'option', optionName: "legend"): IgDataChartLegend;
	igDataChart(optionLiteral: 'option', optionName: "legend", optionValue: IgDataChartLegend): void;
	igDataChart(optionLiteral: 'option', optionName: "axes"): IgDataChartAxes[];
	igDataChart(optionLiteral: 'option', optionName: "axes", optionValue: IgDataChartAxes[]): void;
	igDataChart(optionLiteral: 'option', optionName: "series"): IgDataChartSeries[];
	igDataChart(optionLiteral: 'option', optionName: "series", optionValue: IgDataChartSeries[]): void;
	igDataChart(optionLiteral: 'option', optionName: "theme"): string;
	igDataChart(optionLiteral: 'option', optionName: "theme", optionValue: string): void;
	igDataChart(optionLiteral: 'option', optionName: "tooltipShowing"): TooltipShowingEvent;
	igDataChart(optionLiteral: 'option', optionName: "tooltipShowing", optionValue: TooltipShowingEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "tooltipShown"): TooltipShownEvent;
	igDataChart(optionLiteral: 'option', optionName: "tooltipShown", optionValue: TooltipShownEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "tooltipHiding"): TooltipHidingEvent;
	igDataChart(optionLiteral: 'option', optionName: "tooltipHiding", optionValue: TooltipHidingEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "tooltipHidden"): TooltipHiddenEvent;
	igDataChart(optionLiteral: 'option', optionName: "tooltipHidden", optionValue: TooltipHiddenEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "browserNotSupported"): BrowserNotSupportedEvent;
	igDataChart(optionLiteral: 'option', optionName: "browserNotSupported", optionValue: BrowserNotSupportedEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "seriesCursorMouseMove"): SeriesCursorMouseMoveEvent;
	igDataChart(optionLiteral: 'option', optionName: "seriesCursorMouseMove", optionValue: SeriesCursorMouseMoveEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "seriesMouseLeftButtonDown"): SeriesMouseLeftButtonDownEvent;
	igDataChart(optionLiteral: 'option', optionName: "seriesMouseLeftButtonDown", optionValue: SeriesMouseLeftButtonDownEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "seriesMouseLeftButtonUp"): SeriesMouseLeftButtonUpEvent;
	igDataChart(optionLiteral: 'option', optionName: "seriesMouseLeftButtonUp", optionValue: SeriesMouseLeftButtonUpEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "seriesMouseMove"): SeriesMouseMoveEvent;
	igDataChart(optionLiteral: 'option', optionName: "seriesMouseMove", optionValue: SeriesMouseMoveEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "seriesMouseEnter"): SeriesMouseEnterEvent;
	igDataChart(optionLiteral: 'option', optionName: "seriesMouseEnter", optionValue: SeriesMouseEnterEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "seriesMouseLeave"): SeriesMouseLeaveEvent;
	igDataChart(optionLiteral: 'option', optionName: "seriesMouseLeave", optionValue: SeriesMouseLeaveEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "windowRectChanged"): WindowRectChangedEvent;
	igDataChart(optionLiteral: 'option', optionName: "windowRectChanged", optionValue: WindowRectChangedEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "gridAreaRectChanged"): GridAreaRectChangedEvent;
	igDataChart(optionLiteral: 'option', optionName: "gridAreaRectChanged", optionValue: GridAreaRectChangedEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "refreshCompleted"): RefreshCompletedEvent;
	igDataChart(optionLiteral: 'option', optionName: "refreshCompleted", optionValue: RefreshCompletedEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "axisRangeChanged"): AxisRangeChangedEvent;
	igDataChart(optionLiteral: 'option', optionName: "axisRangeChanged", optionValue: AxisRangeChangedEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "typicalBasedOn"): TypicalBasedOnEvent;
	igDataChart(optionLiteral: 'option', optionName: "typicalBasedOn", optionValue: TypicalBasedOnEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "progressiveLoadStatusChanged"): ProgressiveLoadStatusChangedEvent;
	igDataChart(optionLiteral: 'option', optionName: "progressiveLoadStatusChanged", optionValue: ProgressiveLoadStatusChangedEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "assigningCategoryStyle"): AssigningCategoryStyleEvent;
	igDataChart(optionLiteral: 'option', optionName: "assigningCategoryStyle", optionValue: AssigningCategoryStyleEvent): void;
	igDataChart(optionLiteral: 'option', optionName: "assigningCategoryMarkerStyle"): AssigningCategoryMarkerStyleEvent;
	igDataChart(optionLiteral: 'option', optionName: "assigningCategoryMarkerStyle", optionValue: AssigningCategoryMarkerStyleEvent): void;
	igDataChart(options: IgDataChart): JQuery;
	igDataChart(optionLiteral: 'option', optionName: string): any;
	igDataChart(optionLiteral: 'option', options: IgDataChart): JQuery;
	igDataChart(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igDataChart(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igPieChart(methodName: "option"): void;
	igPieChart(methodName: "addItem", item: Object): void;
	igPieChart(methodName: "insertItem", item: Object, index: number): void;
	igPieChart(methodName: "removeItem", index: number): void;
	igPieChart(methodName: "setItem", index: number, item: Object): void;
	igPieChart(methodName: "exportImage", width?: Object, height?: Object): Object;
	igPieChart(methodName: "destroy"): void;
	igPieChart(methodName: "id"): string;
	igPieChart(methodName: "widget"): void;
	igPieChart(methodName: "print"): void;
	igPieChart(methodName: "exportVisualData"): void;
	igPieChart(optionLiteral: 'option', optionName: "width"): any;
	igPieChart(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "height"): any;
	igPieChart(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "dataSource"): any;
	igPieChart(optionLiteral: 'option', optionName: "dataSource", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "dataSourceUrl"): string;
	igPieChart(optionLiteral: 'option', optionName: "dataSourceUrl", optionValue: string): void;
	igPieChart(optionLiteral: 'option', optionName: "dataSourceType"): string;
	igPieChart(optionLiteral: 'option', optionName: "dataSourceType", optionValue: string): void;
	igPieChart(optionLiteral: 'option', optionName: "responseDataKey"): string;
	igPieChart(optionLiteral: 'option', optionName: "responseDataKey", optionValue: string): void;
	igPieChart(optionLiteral: 'option', optionName: "valueMemberPath"): string;
	igPieChart(optionLiteral: 'option', optionName: "valueMemberPath", optionValue: string): void;
	igPieChart(optionLiteral: 'option', optionName: "labelMemberPath"): string;
	igPieChart(optionLiteral: 'option', optionName: "labelMemberPath", optionValue: string): void;
	igPieChart(optionLiteral: 'option', optionName: "labelsPosition"): any;
	igPieChart(optionLiteral: 'option', optionName: "labelsPosition", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "leaderLineVisibility"): any;
	igPieChart(optionLiteral: 'option', optionName: "leaderLineVisibility", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "leaderLineType"): any;
	igPieChart(optionLiteral: 'option', optionName: "leaderLineType", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "leaderLineMargin"): number;
	igPieChart(optionLiteral: 'option', optionName: "leaderLineMargin", optionValue: number): void;
	igPieChart(optionLiteral: 'option', optionName: "othersCategoryThreshold"): number;
	igPieChart(optionLiteral: 'option', optionName: "othersCategoryThreshold", optionValue: number): void;
	igPieChart(optionLiteral: 'option', optionName: "formatLabel"): Function;
	igPieChart(optionLiteral: 'option', optionName: "formatLabel", optionValue: Function): void;
	igPieChart(optionLiteral: 'option', optionName: "othersCategoryStyle"): any;
	igPieChart(optionLiteral: 'option', optionName: "othersCategoryStyle", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "othersCategoryType"): any;
	igPieChart(optionLiteral: 'option', optionName: "othersCategoryType", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "othersCategoryText"): string;
	igPieChart(optionLiteral: 'option', optionName: "othersCategoryText", optionValue: string): void;
	igPieChart(optionLiteral: 'option', optionName: "explodedRadius"): number;
	igPieChart(optionLiteral: 'option', optionName: "explodedRadius", optionValue: number): void;
	igPieChart(optionLiteral: 'option', optionName: "radiusFactor"): number;
	igPieChart(optionLiteral: 'option', optionName: "radiusFactor", optionValue: number): void;
	igPieChart(optionLiteral: 'option', optionName: "allowSliceSelection"): boolean;
	igPieChart(optionLiteral: 'option', optionName: "allowSliceSelection", optionValue: boolean): void;
	igPieChart(optionLiteral: 'option', optionName: "allowSliceExplosion"): boolean;
	igPieChart(optionLiteral: 'option', optionName: "allowSliceExplosion", optionValue: boolean): void;
	igPieChart(optionLiteral: 'option', optionName: "explodedSlices"): any[];
	igPieChart(optionLiteral: 'option', optionName: "explodedSlices", optionValue: any[]): void;
	igPieChart(optionLiteral: 'option', optionName: "showTooltip"): boolean;
	igPieChart(optionLiteral: 'option', optionName: "showTooltip", optionValue: boolean): void;
	igPieChart(optionLiteral: 'option', optionName: "tooltipTemplate"): string;
	igPieChart(optionLiteral: 'option', optionName: "tooltipTemplate", optionValue: string): void;
	igPieChart(optionLiteral: 'option', optionName: "legend"): IgPieChartLegend;
	igPieChart(optionLiteral: 'option', optionName: "legend", optionValue: IgPieChartLegend): void;
	igPieChart(optionLiteral: 'option', optionName: "labelExtent"): number;
	igPieChart(optionLiteral: 'option', optionName: "labelExtent", optionValue: number): void;
	igPieChart(optionLiteral: 'option', optionName: "startAngle"): number;
	igPieChart(optionLiteral: 'option', optionName: "startAngle", optionValue: number): void;
	igPieChart(optionLiteral: 'option', optionName: "sweepDirection"): any;
	igPieChart(optionLiteral: 'option', optionName: "sweepDirection", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "selectedStyle"): any;
	igPieChart(optionLiteral: 'option', optionName: "selectedStyle", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "brushes"): any;
	igPieChart(optionLiteral: 'option', optionName: "brushes", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "outlines"): any;
	igPieChart(optionLiteral: 'option', optionName: "outlines", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "legendItemTemplate"): any;
	igPieChart(optionLiteral: 'option', optionName: "legendItemTemplate", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "legendItemBadgeTemplate"): any;
	igPieChart(optionLiteral: 'option', optionName: "legendItemBadgeTemplate", optionValue: any): void;
	igPieChart(optionLiteral: 'option', optionName: "textStyle"): string;
	igPieChart(optionLiteral: 'option', optionName: "textStyle", optionValue: string): void;
	igPieChart(optionLiteral: 'option', optionName: "theme"): string;
	igPieChart(optionLiteral: 'option', optionName: "theme", optionValue: string): void;
	igPieChart(optionLiteral: 'option', optionName: "tooltipShowing"): TooltipShowingEvent;
	igPieChart(optionLiteral: 'option', optionName: "tooltipShowing", optionValue: TooltipShowingEvent): void;
	igPieChart(optionLiteral: 'option', optionName: "tooltipShown"): TooltipShownEvent;
	igPieChart(optionLiteral: 'option', optionName: "tooltipShown", optionValue: TooltipShownEvent): void;
	igPieChart(optionLiteral: 'option', optionName: "tooltipHiding"): TooltipHidingEvent;
	igPieChart(optionLiteral: 'option', optionName: "tooltipHiding", optionValue: TooltipHidingEvent): void;
	igPieChart(optionLiteral: 'option', optionName: "tooltipHidden"): TooltipHiddenEvent;
	igPieChart(optionLiteral: 'option', optionName: "tooltipHidden", optionValue: TooltipHiddenEvent): void;
	igPieChart(optionLiteral: 'option', optionName: "browserNotSupported"): BrowserNotSupportedEvent;
	igPieChart(optionLiteral: 'option', optionName: "browserNotSupported", optionValue: BrowserNotSupportedEvent): void;
	igPieChart(optionLiteral: 'option', optionName: "sliceClick"): SliceClickEvent;
	igPieChart(optionLiteral: 'option', optionName: "sliceClick", optionValue: SliceClickEvent): void;
	igPieChart(options: IgPieChart): JQuery;
	igPieChart(optionLiteral: 'option', optionName: string): any;
	igPieChart(optionLiteral: 'option', options: IgPieChart): JQuery;
	igPieChart(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igPieChart(methodName: string, ...methodParams: any[]): any;
}
interface LegendItemMouseLeftButtonDownEvent {
	(event: Event, ui: LegendItemMouseLeftButtonDownEventUIParam): void;
}

interface LegendItemMouseLeftButtonDownEventUIParam {
	legend?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
	item?: any;
}

interface LegendItemMouseLeftButtonUpEvent {
	(event: Event, ui: LegendItemMouseLeftButtonUpEventUIParam): void;
}

interface LegendItemMouseLeftButtonUpEventUIParam {
	legend?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
	item?: any;
}

interface LegendItemMouseEnterEvent {
	(event: Event, ui: LegendItemMouseEnterEventUIParam): void;
}

interface LegendItemMouseEnterEventUIParam {
	legend?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
	item?: any;
}

interface LegendItemMouseLeaveEvent {
	(event: Event, ui: LegendItemMouseLeaveEventUIParam): void;
}

interface LegendItemMouseLeaveEventUIParam {
	legend?: any;
	chart?: any;
	series?: any;
	actualItemBrush?: any;
	actualSeriesBrush?: any;
	item?: any;
}

interface IgChartLegend {
	type?: any;
	width?: any;
	height?: any;
	theme?: string;
	legendItemMouseLeftButtonDown?: LegendItemMouseLeftButtonDownEvent;
	legendItemMouseLeftButtonUp?: LegendItemMouseLeftButtonUpEvent;
	legendItemMouseEnter?: LegendItemMouseEnterEvent;
	legendItemMouseLeave?: LegendItemMouseLeaveEvent;
}
interface IgChartLegendMethods {
	exportVisualData(): void;
	destroy(): void;
	widget(): void;
	id(): string;
}
interface JQuery {
	data(propertyName: "igChartLegend"):IgChartLegendMethods;
}

interface JQuery {
	igChartLegend(methodName: "exportVisualData"): void;
	igChartLegend(methodName: "destroy"): void;
	igChartLegend(methodName: "widget"): void;
	igChartLegend(methodName: "id"): string;
	igChartLegend(optionLiteral: 'option', optionName: "type"): any;
	igChartLegend(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igChartLegend(optionLiteral: 'option', optionName: "width"): any;
	igChartLegend(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igChartLegend(optionLiteral: 'option', optionName: "height"): any;
	igChartLegend(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igChartLegend(optionLiteral: 'option', optionName: "theme"): string;
	igChartLegend(optionLiteral: 'option', optionName: "theme", optionValue: string): void;
	igChartLegend(optionLiteral: 'option', optionName: "legendItemMouseLeftButtonDown"): LegendItemMouseLeftButtonDownEvent;
	igChartLegend(optionLiteral: 'option', optionName: "legendItemMouseLeftButtonDown", optionValue: LegendItemMouseLeftButtonDownEvent): void;
	igChartLegend(optionLiteral: 'option', optionName: "legendItemMouseLeftButtonUp"): LegendItemMouseLeftButtonUpEvent;
	igChartLegend(optionLiteral: 'option', optionName: "legendItemMouseLeftButtonUp", optionValue: LegendItemMouseLeftButtonUpEvent): void;
	igChartLegend(optionLiteral: 'option', optionName: "legendItemMouseEnter"): LegendItemMouseEnterEvent;
	igChartLegend(optionLiteral: 'option', optionName: "legendItemMouseEnter", optionValue: LegendItemMouseEnterEvent): void;
	igChartLegend(optionLiteral: 'option', optionName: "legendItemMouseLeave"): LegendItemMouseLeaveEvent;
	igChartLegend(optionLiteral: 'option', optionName: "legendItemMouseLeave", optionValue: LegendItemMouseLeaveEvent): void;
	igChartLegend(options: IgChartLegend): JQuery;
	igChartLegend(optionLiteral: 'option', optionName: string): any;
	igChartLegend(optionLiteral: 'option', options: IgChartLegend): JQuery;
	igChartLegend(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igChartLegend(methodName: string, ...methodParams: any[]): any;
}
interface ColorSelectedEvent {
	(event: Event, ui: ColorSelectedEventUIParam): void;
}

interface ColorSelectedEventUIParam {
}

interface IgColorPicker {
	colors?: any[];
	standardColors?: any[];
	colorSelected?: ColorSelectedEvent;
}
interface IgColorPickerMethods {
	selectColor(color: Object): void;
}
interface JQuery {
	data(propertyName: "igColorPicker"):IgColorPickerMethods;
}

interface JQuery {
	igColorPicker(methodName: "selectColor", color: Object): void;
	igColorPicker(optionLiteral: 'option', optionName: "colors"): any[];
	igColorPicker(optionLiteral: 'option', optionName: "colors", optionValue: any[]): void;
	igColorPicker(optionLiteral: 'option', optionName: "standardColors"): any[];
	igColorPicker(optionLiteral: 'option', optionName: "standardColors", optionValue: any[]): void;
	igColorPicker(optionLiteral: 'option', optionName: "colorSelected"): ColorSelectedEvent;
	igColorPicker(optionLiteral: 'option', optionName: "colorSelected", optionValue: ColorSelectedEvent): void;
	igColorPicker(options: IgColorPicker): JQuery;
	igColorPicker(optionLiteral: 'option', optionName: string): any;
	igColorPicker(optionLiteral: 'option', options: IgColorPicker): JQuery;
	igColorPicker(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igColorPicker(methodName: string, ...methodParams: any[]): any;
}
interface IgSplitButtonItem {
	name?: string;
	label?: string;
	iconClass?: string;
}

interface ClickEvent {
	(event: Event, ui: ClickEventUIParam): void;
}

interface ClickEventUIParam {
}

interface ExpandedEvent {
	(event: Event, ui: ExpandedEventUIParam): void;
}

interface ExpandedEventUIParam {
}

interface ExpandingEvent {
	(event: Event, ui: ExpandingEventUIParam): void;
}

interface ExpandingEventUIParam {
}

interface CollapsedEvent {
	(event: Event, ui: CollapsedEventUIParam): void;
}

interface CollapsedEventUIParam {
}

interface CollapsingEvent {
	(event: Event, ui: CollapsingEventUIParam): void;
}

interface CollapsingEventUIParam {
}

interface IgColorPickerSplitButton {
	items?: any[];
	defaultColor?: string;
	hasDefaultIcon?: boolean;
	items?: IgSplitButtonItem[];
	defaultItemName?: string;
	swapDefaultEnabled?: boolean;
	click?: ClickEvent;
	expanded?: ExpandedEvent;
	expanding?: ExpandingEvent;
	collapsed?: CollapsedEvent;
	collapsing?: CollapsingEvent;
}
interface IgColorPickerSplitButtonMethods {
	collapse(e: Object): void;
	expand(e: Object): void;
	setColor(color: Object): void;
	destroy(): void;
	switchToButton(button: Object): void;
	widget(): void;
	toggle(e: Object): void;
}
interface JQuery {
	data(propertyName: "igColorPickerSplitButton"):IgColorPickerSplitButtonMethods;
}

interface JQuery {
	igColorPickerSplitButton(methodName: "collapse", e: Object): void;
	igColorPickerSplitButton(methodName: "expand", e: Object): void;
	igColorPickerSplitButton(methodName: "setColor", color: Object): void;
	igColorPickerSplitButton(methodName: "destroy"): void;
	igColorPickerSplitButton(methodName: "switchToButton", button: Object): void;
	igColorPickerSplitButton(methodName: "widget"): void;
	igColorPickerSplitButton(methodName: "toggle", e: Object): void;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "items"): any[];
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "items", optionValue: any[]): void;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "defaultColor"): string;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "defaultColor", optionValue: string): void;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "hasDefaultIcon"): boolean;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "hasDefaultIcon", optionValue: boolean): void;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "items"): IgSplitButtonItem[];
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "items", optionValue: IgSplitButtonItem[]): void;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "defaultItemName"): string;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "defaultItemName", optionValue: string): void;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "swapDefaultEnabled"): boolean;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "swapDefaultEnabled", optionValue: boolean): void;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "click"): ClickEvent;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "click", optionValue: ClickEvent): void;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "expanded"): ExpandedEvent;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "expanded", optionValue: ExpandedEvent): void;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "expanding"): ExpandingEvent;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "expanding", optionValue: ExpandingEvent): void;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "collapsed"): CollapsedEvent;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "collapsed", optionValue: CollapsedEvent): void;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "collapsing"): CollapsingEvent;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: "collapsing", optionValue: CollapsingEvent): void;
	igColorPickerSplitButton(options: IgColorPickerSplitButton): JQuery;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: string): any;
	igColorPickerSplitButton(optionLiteral: 'option', options: IgColorPickerSplitButton): JQuery;
	igColorPickerSplitButton(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igColorPickerSplitButton(methodName: string, ...methodParams: any[]): any;
}
interface IgComboLoadOnDemandSettings {
	enabled?: boolean;
	pageSize?: number;
}

interface IgComboMultiSelection {
	enabled?: boolean;
	addWithKeyModifier?: boolean;
	showCheckboxes?: boolean;
	itemSeparator?: boolean;
}

interface IgComboInitialSelectedItem {
	index?: number;
	value?: any;
}

interface RenderedEvent {
	(event: Event, ui: RenderedEventUIParam): void;
}

interface RenderedEventUIParam {
	owner?: any;
	element?: any;
}

interface FilteringEvent {
	(event: Event, ui: FilteringEventUIParam): void;
}

interface FilteringEventUIParam {
	owner?: any;
	expression?: any;
}

interface FilteredEvent {
	(event: Event, ui: FilteredEventUIParam): void;
}

interface FilteredEventUIParam {
	owner?: any;
	elements?: any;
}

interface ItemsRenderingEvent {
	(event: Event, ui: ItemsRenderingEventUIParam): void;
}

interface ItemsRenderingEventUIParam {
	owner?: any;
	dataSource?: any;
}

interface ItemsRenderedEvent {
	(event: Event, ui: ItemsRenderedEventUIParam): void;
}

interface ItemsRenderedEventUIParam {
	owner?: any;
	dataSource?: any;
}

interface DropDownOpeningEvent {
	(event: Event, ui: DropDownOpeningEventUIParam): void;
}

interface DropDownOpeningEventUIParam {
	owner?: any;
	list?: any;
}

interface DropDownOpenedEvent {
	(event: Event, ui: DropDownOpenedEventUIParam): void;
}

interface DropDownOpenedEventUIParam {
	owner?: any;
	list?: any;
}

interface DropDownClosingEvent {
	(event: Event, ui: DropDownClosingEventUIParam): void;
}

interface DropDownClosingEventUIParam {
	owner?: any;
	list?: any;
}

interface DropDownClosedEvent {
	(event: Event, ui: DropDownClosedEventUIParam): void;
}

interface DropDownClosedEventUIParam {
	owner?: any;
	list?: any;
}

interface SelectionChangingEvent {
	(event: Event, ui: SelectionChangingEventUIParam): void;
}

interface SelectionChangingEventUIParam {
	owner?: any;
	currentItems?: any;
	items?: any;
}

interface SelectionChangedEvent {
	(event: Event, ui: SelectionChangedEventUIParam): void;
}

interface SelectionChangedEventUIParam {
	owner?: any;
	items?: any;
	oldItems?: any;
}

interface IgCombo {
	width?: any;
	height?: any;
	dropDownWidth?: any;
	dataSource?: any;
	dataSourceType?: string;
	dataSourceUrl?: string;
	responseTotalRecCountKey?: string;
	responseDataKey?: string;
	responseDataType?: any;
	responseContentType?: string;
	requestType?: string;
	valueKey?: string;
	textKey?: string;
	itemTemplate?: string;
	headerTemplate?: string;
	footerTemplate?: string;
	inputName?: any;
	animationShowDuration?: number;
	animationHideDuration?: number;
	dropDownAttachedToBody?: boolean;
	filteringType?: any;
	filterExprUrlKey?: string;
	filteringCondition?: any;
	filteringLogic?: any;
	noMatchFoundText?: string;
	loadOnDemandSettings?: IgComboLoadOnDemandSettings;
	visibleItemsCount?: number;
	placeHolder?: string;
	mode?: any;
	virtualization?: boolean;
	multiSelection?: IgComboMultiSelection;
	validatorOptions?: any;
	highlightMatchesMode?: any;
	caseSensitive?: boolean;
	autoSelectFirstMatch?: boolean;
	autoComplete?: boolean;
	allowCustomValue?: boolean;
	closeDropDownOnBlur?: boolean;
	delayInputChangeProcessing?: number;
	tabIndex?: number;
	dropDownOnFocus?: boolean;
	closeDropDownOnSelect?: boolean;
	selectItemBySpaceKey?: boolean;
	initialSelectedItems?: IgComboInitialSelectedItem[];
	preventSubmitOnEnter?: boolean;
	format?: string;
	enableClearButton?: boolean;
	dropDownButtonTitle?: string;
	clearButtonTitle?: string;
	dropDownOrientation?: any;
	rendered?: RenderedEvent;
	dataBinding?: DataBindingEvent;
	dataBound?: DataBoundEvent;
	filtering?: FilteringEvent;
	filtered?: FilteredEvent;
	itemsRendering?: ItemsRenderingEvent;
	itemsRendered?: ItemsRenderedEvent;
	dropDownOpening?: DropDownOpeningEvent;
	dropDownOpened?: DropDownOpenedEvent;
	dropDownClosing?: DropDownClosingEvent;
	dropDownClosed?: DropDownClosedEvent;
	selectionChanging?: SelectionChangingEvent;
	selectionChanged?: SelectionChangedEvent;
}
interface IgComboMethods {
	dataBind(): Object;
	refreshValue(): void;
	dataForValue(value: Object): Object;
	dataForElement($element: Object): Object;
	itemsFromElement($element: Object): Object;
	itemsFromValue(value: Object): Object;
	itemsFromIndex(index: number): Object;
	items(): Object;
	filteredItems(): Object;
	selectedItems(): Object;
	filter(texts?: Object, event?: Object): Object;
	clearFiltering(event: Object): Object;
	openDropDown(callback?: Function, focusCombo?: Object, event?: boolean): Object;
	closeDropDown(callback?: Function, event?: Object): Object;
	clearInput(event: Object): Object;
	isSelected($item: Object): boolean;
	isValueSelected(value: Object): boolean;
	isIndexSelected(index: Object): boolean;
	value(value?: Object, options?: Object, event?: Object): Object;
	select($items: Object, options?: Object, event?: Object): Object;
	index(index?: Object, options?: Object, event?: Object): Object;
	selectAll(options?: Object, event?: Object): Object;
	deselectByValue(value: Object, options?: Object, event?: Object): Object;
	deselect($items: Object, options?: Object, event?: Object): Object;
	deselectByIndex(index: Object, options?: Object, event?: Object): Object;
	deselectAll(options?: Object, event?: Object): Object;
	activeIndex(index?: number): void;
	text(text?: string): void;
	listScrollTop(value?: number): void;
	listItems(): Object;
	comboWrapper(): Object;
	dropDown(): Object;
	list(): Object;
	textInput(): Object;
	valueInput(): Object;
	validator(destroy?: boolean): Object;
	validate(): void;
	dropDownOpened(): boolean;
	positionDropDown(): void;
	destroy(): Object;
}
interface JQuery {
	data(propertyName: "igCombo"):IgComboMethods;
}

interface JQuery {
	igCombo(methodName: "dataBind"): Object;
	igCombo(methodName: "refreshValue"): void;
	igCombo(methodName: "dataForValue", value: Object): Object;
	igCombo(methodName: "dataForElement", $element: Object): Object;
	igCombo(methodName: "itemsFromElement", $element: Object): Object;
	igCombo(methodName: "itemsFromValue", value: Object): Object;
	igCombo(methodName: "itemsFromIndex", index: number): Object;
	igCombo(methodName: "items"): Object;
	igCombo(methodName: "filteredItems"): Object;
	igCombo(methodName: "selectedItems"): Object;
	igCombo(methodName: "filter", texts?: Object, event?: Object): Object;
	igCombo(methodName: "clearFiltering", event: Object): Object;
	igCombo(methodName: "openDropDown", callback?: Function, focusCombo?: Object, event?: boolean): Object;
	igCombo(methodName: "closeDropDown", callback?: Function, event?: Object): Object;
	igCombo(methodName: "clearInput", event: Object): Object;
	igCombo(methodName: "isSelected", $item: Object): boolean;
	igCombo(methodName: "isValueSelected", value: Object): boolean;
	igCombo(methodName: "isIndexSelected", index: Object): boolean;
	igCombo(methodName: "value", value?: Object, options?: Object, event?: Object): Object;
	igCombo(methodName: "select", $items: Object, options?: Object, event?: Object): Object;
	igCombo(methodName: "index", index?: Object, options?: Object, event?: Object): Object;
	igCombo(methodName: "selectAll", options?: Object, event?: Object): Object;
	igCombo(methodName: "deselectByValue", value: Object, options?: Object, event?: Object): Object;
	igCombo(methodName: "deselect", $items: Object, options?: Object, event?: Object): Object;
	igCombo(methodName: "deselectByIndex", index: Object, options?: Object, event?: Object): Object;
	igCombo(methodName: "deselectAll", options?: Object, event?: Object): Object;
	igCombo(methodName: "activeIndex", index?: number): void;
	igCombo(methodName: "text", text?: string): void;
	igCombo(methodName: "listScrollTop", value?: number): void;
	igCombo(methodName: "listItems"): Object;
	igCombo(methodName: "comboWrapper"): Object;
	igCombo(methodName: "dropDown"): Object;
	igCombo(methodName: "list"): Object;
	igCombo(methodName: "textInput"): Object;
	igCombo(methodName: "valueInput"): Object;
	igCombo(methodName: "validator", destroy?: boolean): Object;
	igCombo(methodName: "validate"): void;
	igCombo(methodName: "dropDownOpened"): boolean;
	igCombo(methodName: "positionDropDown"): void;
	igCombo(methodName: "destroy"): Object;
	igCombo(optionLiteral: 'option', optionName: "width"): any;
	igCombo(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "height"): any;
	igCombo(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "dropDownWidth"): any;
	igCombo(optionLiteral: 'option', optionName: "dropDownWidth", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "dataSource"): any;
	igCombo(optionLiteral: 'option', optionName: "dataSource", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "dataSourceType"): string;
	igCombo(optionLiteral: 'option', optionName: "dataSourceType", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "dataSourceUrl"): string;
	igCombo(optionLiteral: 'option', optionName: "dataSourceUrl", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "responseTotalRecCountKey"): string;
	igCombo(optionLiteral: 'option', optionName: "responseTotalRecCountKey", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "responseDataKey"): string;
	igCombo(optionLiteral: 'option', optionName: "responseDataKey", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "responseDataType"): any;
	igCombo(optionLiteral: 'option', optionName: "responseDataType", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "responseContentType"): string;
	igCombo(optionLiteral: 'option', optionName: "responseContentType", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "requestType"): string;
	igCombo(optionLiteral: 'option', optionName: "requestType", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "valueKey"): string;
	igCombo(optionLiteral: 'option', optionName: "valueKey", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "textKey"): string;
	igCombo(optionLiteral: 'option', optionName: "textKey", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "itemTemplate"): string;
	igCombo(optionLiteral: 'option', optionName: "itemTemplate", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "headerTemplate"): string;
	igCombo(optionLiteral: 'option', optionName: "headerTemplate", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "footerTemplate"): string;
	igCombo(optionLiteral: 'option', optionName: "footerTemplate", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "inputName"): any;
	igCombo(optionLiteral: 'option', optionName: "inputName", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "animationShowDuration"): number;
	igCombo(optionLiteral: 'option', optionName: "animationShowDuration", optionValue: number): void;
	igCombo(optionLiteral: 'option', optionName: "animationHideDuration"): number;
	igCombo(optionLiteral: 'option', optionName: "animationHideDuration", optionValue: number): void;
	igCombo(optionLiteral: 'option', optionName: "dropDownAttachedToBody"): boolean;
	igCombo(optionLiteral: 'option', optionName: "dropDownAttachedToBody", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "filteringType"): any;
	igCombo(optionLiteral: 'option', optionName: "filteringType", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "filterExprUrlKey"): string;
	igCombo(optionLiteral: 'option', optionName: "filterExprUrlKey", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "filteringCondition"): any;
	igCombo(optionLiteral: 'option', optionName: "filteringCondition", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "filteringLogic"): any;
	igCombo(optionLiteral: 'option', optionName: "filteringLogic", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "noMatchFoundText"): string;
	igCombo(optionLiteral: 'option', optionName: "noMatchFoundText", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "loadOnDemandSettings"): IgComboLoadOnDemandSettings;
	igCombo(optionLiteral: 'option', optionName: "loadOnDemandSettings", optionValue: IgComboLoadOnDemandSettings): void;
	igCombo(optionLiteral: 'option', optionName: "visibleItemsCount"): number;
	igCombo(optionLiteral: 'option', optionName: "visibleItemsCount", optionValue: number): void;
	igCombo(optionLiteral: 'option', optionName: "placeHolder"): string;
	igCombo(optionLiteral: 'option', optionName: "placeHolder", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "mode"): any;
	igCombo(optionLiteral: 'option', optionName: "mode", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "virtualization"): boolean;
	igCombo(optionLiteral: 'option', optionName: "virtualization", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "multiSelection"): IgComboMultiSelection;
	igCombo(optionLiteral: 'option', optionName: "multiSelection", optionValue: IgComboMultiSelection): void;
	igCombo(optionLiteral: 'option', optionName: "validatorOptions"): any;
	igCombo(optionLiteral: 'option', optionName: "validatorOptions", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "highlightMatchesMode"): any;
	igCombo(optionLiteral: 'option', optionName: "highlightMatchesMode", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "caseSensitive"): boolean;
	igCombo(optionLiteral: 'option', optionName: "caseSensitive", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "autoSelectFirstMatch"): boolean;
	igCombo(optionLiteral: 'option', optionName: "autoSelectFirstMatch", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "autoComplete"): boolean;
	igCombo(optionLiteral: 'option', optionName: "autoComplete", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "allowCustomValue"): boolean;
	igCombo(optionLiteral: 'option', optionName: "allowCustomValue", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "closeDropDownOnBlur"): boolean;
	igCombo(optionLiteral: 'option', optionName: "closeDropDownOnBlur", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "delayInputChangeProcessing"): number;
	igCombo(optionLiteral: 'option', optionName: "delayInputChangeProcessing", optionValue: number): void;
	igCombo(optionLiteral: 'option', optionName: "tabIndex"): number;
	igCombo(optionLiteral: 'option', optionName: "tabIndex", optionValue: number): void;
	igCombo(optionLiteral: 'option', optionName: "dropDownOnFocus"): boolean;
	igCombo(optionLiteral: 'option', optionName: "dropDownOnFocus", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "closeDropDownOnSelect"): boolean;
	igCombo(optionLiteral: 'option', optionName: "closeDropDownOnSelect", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "selectItemBySpaceKey"): boolean;
	igCombo(optionLiteral: 'option', optionName: "selectItemBySpaceKey", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "initialSelectedItems"): IgComboInitialSelectedItem[];
	igCombo(optionLiteral: 'option', optionName: "initialSelectedItems", optionValue: IgComboInitialSelectedItem[]): void;
	igCombo(optionLiteral: 'option', optionName: "preventSubmitOnEnter"): boolean;
	igCombo(optionLiteral: 'option', optionName: "preventSubmitOnEnter", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "format"): string;
	igCombo(optionLiteral: 'option', optionName: "format", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "enableClearButton"): boolean;
	igCombo(optionLiteral: 'option', optionName: "enableClearButton", optionValue: boolean): void;
	igCombo(optionLiteral: 'option', optionName: "dropDownButtonTitle"): string;
	igCombo(optionLiteral: 'option', optionName: "dropDownButtonTitle", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "clearButtonTitle"): string;
	igCombo(optionLiteral: 'option', optionName: "clearButtonTitle", optionValue: string): void;
	igCombo(optionLiteral: 'option', optionName: "dropDownOrientation"): any;
	igCombo(optionLiteral: 'option', optionName: "dropDownOrientation", optionValue: any): void;
	igCombo(optionLiteral: 'option', optionName: "rendered"): RenderedEvent;
	igCombo(optionLiteral: 'option', optionName: "rendered", optionValue: RenderedEvent): void;
	igCombo(optionLiteral: 'option', optionName: "dataBinding"): DataBindingEvent;
	igCombo(optionLiteral: 'option', optionName: "dataBinding", optionValue: DataBindingEvent): void;
	igCombo(optionLiteral: 'option', optionName: "dataBound"): DataBoundEvent;
	igCombo(optionLiteral: 'option', optionName: "dataBound", optionValue: DataBoundEvent): void;
	igCombo(optionLiteral: 'option', optionName: "filtering"): FilteringEvent;
	igCombo(optionLiteral: 'option', optionName: "filtering", optionValue: FilteringEvent): void;
	igCombo(optionLiteral: 'option', optionName: "filtered"): FilteredEvent;
	igCombo(optionLiteral: 'option', optionName: "filtered", optionValue: FilteredEvent): void;
	igCombo(optionLiteral: 'option', optionName: "itemsRendering"): ItemsRenderingEvent;
	igCombo(optionLiteral: 'option', optionName: "itemsRendering", optionValue: ItemsRenderingEvent): void;
	igCombo(optionLiteral: 'option', optionName: "itemsRendered"): ItemsRenderedEvent;
	igCombo(optionLiteral: 'option', optionName: "itemsRendered", optionValue: ItemsRenderedEvent): void;
	igCombo(optionLiteral: 'option', optionName: "dropDownOpening"): DropDownOpeningEvent;
	igCombo(optionLiteral: 'option', optionName: "dropDownOpening", optionValue: DropDownOpeningEvent): void;
	igCombo(optionLiteral: 'option', optionName: "dropDownOpened"): DropDownOpenedEvent;
	igCombo(optionLiteral: 'option', optionName: "dropDownOpened", optionValue: DropDownOpenedEvent): void;
	igCombo(optionLiteral: 'option', optionName: "dropDownClosing"): DropDownClosingEvent;
	igCombo(optionLiteral: 'option', optionName: "dropDownClosing", optionValue: DropDownClosingEvent): void;
	igCombo(optionLiteral: 'option', optionName: "dropDownClosed"): DropDownClosedEvent;
	igCombo(optionLiteral: 'option', optionName: "dropDownClosed", optionValue: DropDownClosedEvent): void;
	igCombo(optionLiteral: 'option', optionName: "selectionChanging"): SelectionChangingEvent;
	igCombo(optionLiteral: 'option', optionName: "selectionChanging", optionValue: SelectionChangingEvent): void;
	igCombo(optionLiteral: 'option', optionName: "selectionChanged"): SelectionChangedEvent;
	igCombo(optionLiteral: 'option', optionName: "selectionChanged", optionValue: SelectionChangedEvent): void;
	igCombo(options: IgCombo): JQuery;
	igCombo(optionLiteral: 'option', optionName: string): any;
	igCombo(optionLiteral: 'option', options: IgCombo): JQuery;
	igCombo(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igCombo(methodName: string, ...methodParams: any[]): any;
}
interface StateChangingEvent {
	(event: Event, ui: StateChangingEventUIParam): void;
}

interface StateChangingEventUIParam {
	owner?: any;
	button?: any;
	oldState?: any;
	oldPinned?: any;
	action?: any;
}

interface StateChangedEvent {
	(event: Event, ui: StateChangedEventUIParam): void;
}

interface StateChangedEventUIParam {
	owner?: any;
	button?: any;
	oldState?: any;
	oldPinned?: any;
	action?: any;
}

interface AnimationEndedEvent {
	(event: Event, ui: AnimationEndedEventUIParam): void;
}

interface AnimationEndedEventUIParam {
	owner?: any;
	action?: any;
}

interface FocusEvent {
	(event: Event, ui: FocusEventUIParam): void;
}

interface FocusEventUIParam {
	owner?: any;
}

interface BlurEvent {
	(event: Event, ui: BlurEventUIParam): void;
}

interface BlurEventUIParam {
	owner?: any;
}

interface IgDialog {
	mainElement?: Element;
	state?: any;
	pinned?: boolean;
	closeOnEscape?: boolean;
	showCloseButton?: boolean;
	showMaximizeButton?: boolean;
	showMinimizeButton?: boolean;
	showPinButton?: boolean;
	pinOnMinimized?: boolean;
	imageClass?: string;
	headerText?: string;
	showHeader?: boolean;
	showFooter?: boolean;
	footerText?: string;
	dialogClass?: string;
	container?: any;
	height?: number;
	width?: number;
	minHeight?: number;
	minWidth?: number;
	maxHeight?: number;
	maxWidth?: number;
	draggable?: boolean;
	position?: any;
	resizable?: boolean;
	tabIndex?: number;
	openAnimation?: any;
	closeAnimation?: any;
	zIndex?: number;
	modal?: boolean;
	trackFocus?: boolean;
	closeButtonTitle?: string;
	minimizeButtonTitle?: string;
	maximizeButtonTitle?: string;
	pinButtonTitle?: string;
	unpinButtonTitle?: string;
	restoreButtonTitle?: string;
	temporaryUrl?: string;
	enableHeaderFocus?: boolean;
	enableDblclick?: any;
	stateChanging?: StateChangingEvent;
	stateChanged?: StateChangedEvent;
	animationEnded?: AnimationEndedEvent;
	focus?: FocusEvent;
	blur?: BlurEvent;
}
interface IgDialogMethods {
	destroy(): Object;
	state(state?: string): string;
	mainElement(): Element;
	close(e?: Object): Object;
	open(): Object;
	minimize(): Object;
	maximize(): Object;
	restore(): Object;
	pin(): Object;
	unpin(): Object;
	getTopModal(): Object;
	isTopModal(): boolean;
	moveToTop(e?: Object): Object;
	content(newContent?: string): Object;
}
interface JQuery {
	data(propertyName: "igDialog"):IgDialogMethods;
}

interface JQuery {
	igDialog(methodName: "destroy"): Object;
	igDialog(methodName: "state", state?: string): string;
	igDialog(methodName: "mainElement"): Element;
	igDialog(methodName: "close", e?: Object): Object;
	igDialog(methodName: "open"): Object;
	igDialog(methodName: "minimize"): Object;
	igDialog(methodName: "maximize"): Object;
	igDialog(methodName: "restore"): Object;
	igDialog(methodName: "pin"): Object;
	igDialog(methodName: "unpin"): Object;
	igDialog(methodName: "getTopModal"): Object;
	igDialog(methodName: "isTopModal"): boolean;
	igDialog(methodName: "moveToTop", e?: Object): Object;
	igDialog(methodName: "content", newContent?: string): Object;
	igDialog(optionLiteral: 'option', optionName: "mainElement"): Element;
	igDialog(optionLiteral: 'option', optionName: "mainElement", optionValue: Element): void;
	igDialog(optionLiteral: 'option', optionName: "state"): any;
	igDialog(optionLiteral: 'option', optionName: "state", optionValue: any): void;
	igDialog(optionLiteral: 'option', optionName: "pinned"): boolean;
	igDialog(optionLiteral: 'option', optionName: "pinned", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "closeOnEscape"): boolean;
	igDialog(optionLiteral: 'option', optionName: "closeOnEscape", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "showCloseButton"): boolean;
	igDialog(optionLiteral: 'option', optionName: "showCloseButton", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "showMaximizeButton"): boolean;
	igDialog(optionLiteral: 'option', optionName: "showMaximizeButton", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "showMinimizeButton"): boolean;
	igDialog(optionLiteral: 'option', optionName: "showMinimizeButton", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "showPinButton"): boolean;
	igDialog(optionLiteral: 'option', optionName: "showPinButton", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "pinOnMinimized"): boolean;
	igDialog(optionLiteral: 'option', optionName: "pinOnMinimized", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "imageClass"): string;
	igDialog(optionLiteral: 'option', optionName: "imageClass", optionValue: string): void;
	igDialog(optionLiteral: 'option', optionName: "headerText"): string;
	igDialog(optionLiteral: 'option', optionName: "headerText", optionValue: string): void;
	igDialog(optionLiteral: 'option', optionName: "showHeader"): boolean;
	igDialog(optionLiteral: 'option', optionName: "showHeader", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "showFooter"): boolean;
	igDialog(optionLiteral: 'option', optionName: "showFooter", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "footerText"): string;
	igDialog(optionLiteral: 'option', optionName: "footerText", optionValue: string): void;
	igDialog(optionLiteral: 'option', optionName: "dialogClass"): string;
	igDialog(optionLiteral: 'option', optionName: "dialogClass", optionValue: string): void;
	igDialog(optionLiteral: 'option', optionName: "container"): any;
	igDialog(optionLiteral: 'option', optionName: "container", optionValue: any): void;
	igDialog(optionLiteral: 'option', optionName: "height"): number;
	igDialog(optionLiteral: 'option', optionName: "height", optionValue: number): void;
	igDialog(optionLiteral: 'option', optionName: "width"): number;
	igDialog(optionLiteral: 'option', optionName: "width", optionValue: number): void;
	igDialog(optionLiteral: 'option', optionName: "minHeight"): number;
	igDialog(optionLiteral: 'option', optionName: "minHeight", optionValue: number): void;
	igDialog(optionLiteral: 'option', optionName: "minWidth"): number;
	igDialog(optionLiteral: 'option', optionName: "minWidth", optionValue: number): void;
	igDialog(optionLiteral: 'option', optionName: "maxHeight"): number;
	igDialog(optionLiteral: 'option', optionName: "maxHeight", optionValue: number): void;
	igDialog(optionLiteral: 'option', optionName: "maxWidth"): number;
	igDialog(optionLiteral: 'option', optionName: "maxWidth", optionValue: number): void;
	igDialog(optionLiteral: 'option', optionName: "draggable"): boolean;
	igDialog(optionLiteral: 'option', optionName: "draggable", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "position"): any;
	igDialog(optionLiteral: 'option', optionName: "position", optionValue: any): void;
	igDialog(optionLiteral: 'option', optionName: "resizable"): boolean;
	igDialog(optionLiteral: 'option', optionName: "resizable", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "tabIndex"): number;
	igDialog(optionLiteral: 'option', optionName: "tabIndex", optionValue: number): void;
	igDialog(optionLiteral: 'option', optionName: "openAnimation"): any;
	igDialog(optionLiteral: 'option', optionName: "openAnimation", optionValue: any): void;
	igDialog(optionLiteral: 'option', optionName: "closeAnimation"): any;
	igDialog(optionLiteral: 'option', optionName: "closeAnimation", optionValue: any): void;
	igDialog(optionLiteral: 'option', optionName: "zIndex"): number;
	igDialog(optionLiteral: 'option', optionName: "zIndex", optionValue: number): void;
	igDialog(optionLiteral: 'option', optionName: "modal"): boolean;
	igDialog(optionLiteral: 'option', optionName: "modal", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "trackFocus"): boolean;
	igDialog(optionLiteral: 'option', optionName: "trackFocus", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "closeButtonTitle"): string;
	igDialog(optionLiteral: 'option', optionName: "closeButtonTitle", optionValue: string): void;
	igDialog(optionLiteral: 'option', optionName: "minimizeButtonTitle"): string;
	igDialog(optionLiteral: 'option', optionName: "minimizeButtonTitle", optionValue: string): void;
	igDialog(optionLiteral: 'option', optionName: "maximizeButtonTitle"): string;
	igDialog(optionLiteral: 'option', optionName: "maximizeButtonTitle", optionValue: string): void;
	igDialog(optionLiteral: 'option', optionName: "pinButtonTitle"): string;
	igDialog(optionLiteral: 'option', optionName: "pinButtonTitle", optionValue: string): void;
	igDialog(optionLiteral: 'option', optionName: "unpinButtonTitle"): string;
	igDialog(optionLiteral: 'option', optionName: "unpinButtonTitle", optionValue: string): void;
	igDialog(optionLiteral: 'option', optionName: "restoreButtonTitle"): string;
	igDialog(optionLiteral: 'option', optionName: "restoreButtonTitle", optionValue: string): void;
	igDialog(optionLiteral: 'option', optionName: "temporaryUrl"): string;
	igDialog(optionLiteral: 'option', optionName: "temporaryUrl", optionValue: string): void;
	igDialog(optionLiteral: 'option', optionName: "enableHeaderFocus"): boolean;
	igDialog(optionLiteral: 'option', optionName: "enableHeaderFocus", optionValue: boolean): void;
	igDialog(optionLiteral: 'option', optionName: "enableDblclick"): any;
	igDialog(optionLiteral: 'option', optionName: "enableDblclick", optionValue: any): void;
	igDialog(optionLiteral: 'option', optionName: "stateChanging"): StateChangingEvent;
	igDialog(optionLiteral: 'option', optionName: "stateChanging", optionValue: StateChangingEvent): void;
	igDialog(optionLiteral: 'option', optionName: "stateChanged"): StateChangedEvent;
	igDialog(optionLiteral: 'option', optionName: "stateChanged", optionValue: StateChangedEvent): void;
	igDialog(optionLiteral: 'option', optionName: "animationEnded"): AnimationEndedEvent;
	igDialog(optionLiteral: 'option', optionName: "animationEnded", optionValue: AnimationEndedEvent): void;
	igDialog(optionLiteral: 'option', optionName: "focus"): FocusEvent;
	igDialog(optionLiteral: 'option', optionName: "focus", optionValue: FocusEvent): void;
	igDialog(optionLiteral: 'option', optionName: "blur"): BlurEvent;
	igDialog(optionLiteral: 'option', optionName: "blur", optionValue: BlurEvent): void;
	igDialog(options: IgDialog): JQuery;
	igDialog(optionLiteral: 'option', optionName: string): any;
	igDialog(optionLiteral: 'option', options: IgDialog): JQuery;
	igDialog(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igDialog(methodName: string, ...methodParams: any[]): any;
}
interface IgDoughnutChartSeries {
	type?: any;
	showTooltip?: boolean;
	tooltipTemplate?: string;
	itemsSource?: any;
	valueMemberPath?: string;
	labelMemberPath?: string;
	labelsPosition?: any;
	leaderLineVisibility?: any;
	leaderLineStyle?: any;
	leaderLineType?: any;
	leaderLineMargin?: number;
	othersCategoryThreshold?: number;
	othersCategoryType?: any;
	othersCategoryText?: string;
	legend?: any;
	formatLabel?: any;
	labelExtent?: number;
	startAngle?: number;
	selectedStyle?: any;
	brushes?: any;
	outlines?: any;
	isSurfaceInteractionDisabled?: any;
	radiusFactor?: number;
}

interface HoleDimensionsChangedEvent {
	(event: Event, ui: HoleDimensionsChangedEventUIParam): void;
}

interface HoleDimensionsChangedEventUIParam {
}

interface IgDoughnutChart {
	width?: any;
	height?: any;
	series?: IgDoughnutChartSeries[];
	allowSliceSelection?: boolean;
	isSurfaceInteractionDisabled?: any;
	allowSliceExplosion?: boolean;
	innerExtent?: number;
	selectedStyle?: any;
	tooltipShowing?: TooltipShowingEvent;
	tooltipShown?: TooltipShownEvent;
	tooltipHiding?: TooltipHidingEvent;
	tooltipHidden?: TooltipHiddenEvent;
	browserNotSupported?: BrowserNotSupportedEvent;
	sliceClick?: SliceClickEvent;
	holeDimensionsChanged?: HoleDimensionsChangedEvent;
}
interface IgDoughnutChartMethods {
	addSeries(seriesObj: Object): void;
	removeSeries(seriesObj: Object): void;
	updateSeries(value: Object): void;
	getCenterCoordinates(): Object;
	getHoleRadius(): number;
	exportVisualData(): Object;
	flush(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igDoughnutChart"):IgDoughnutChartMethods;
}

interface JQuery {
	igDoughnutChart(methodName: "addSeries", seriesObj: Object): void;
	igDoughnutChart(methodName: "removeSeries", seriesObj: Object): void;
	igDoughnutChart(methodName: "updateSeries", value: Object): void;
	igDoughnutChart(methodName: "getCenterCoordinates"): Object;
	igDoughnutChart(methodName: "getHoleRadius"): number;
	igDoughnutChart(methodName: "exportVisualData"): Object;
	igDoughnutChart(methodName: "flush"): void;
	igDoughnutChart(methodName: "destroy"): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "width"): any;
	igDoughnutChart(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "height"): any;
	igDoughnutChart(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "series"): IgDoughnutChartSeries[];
	igDoughnutChart(optionLiteral: 'option', optionName: "series", optionValue: IgDoughnutChartSeries[]): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "allowSliceSelection"): boolean;
	igDoughnutChart(optionLiteral: 'option', optionName: "allowSliceSelection", optionValue: boolean): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "isSurfaceInteractionDisabled"): any;
	igDoughnutChart(optionLiteral: 'option', optionName: "isSurfaceInteractionDisabled", optionValue: any): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "allowSliceExplosion"): boolean;
	igDoughnutChart(optionLiteral: 'option', optionName: "allowSliceExplosion", optionValue: boolean): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "innerExtent"): number;
	igDoughnutChart(optionLiteral: 'option', optionName: "innerExtent", optionValue: number): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "selectedStyle"): any;
	igDoughnutChart(optionLiteral: 'option', optionName: "selectedStyle", optionValue: any): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "tooltipShowing"): TooltipShowingEvent;
	igDoughnutChart(optionLiteral: 'option', optionName: "tooltipShowing", optionValue: TooltipShowingEvent): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "tooltipShown"): TooltipShownEvent;
	igDoughnutChart(optionLiteral: 'option', optionName: "tooltipShown", optionValue: TooltipShownEvent): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "tooltipHiding"): TooltipHidingEvent;
	igDoughnutChart(optionLiteral: 'option', optionName: "tooltipHiding", optionValue: TooltipHidingEvent): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "tooltipHidden"): TooltipHiddenEvent;
	igDoughnutChart(optionLiteral: 'option', optionName: "tooltipHidden", optionValue: TooltipHiddenEvent): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "browserNotSupported"): BrowserNotSupportedEvent;
	igDoughnutChart(optionLiteral: 'option', optionName: "browserNotSupported", optionValue: BrowserNotSupportedEvent): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "sliceClick"): SliceClickEvent;
	igDoughnutChart(optionLiteral: 'option', optionName: "sliceClick", optionValue: SliceClickEvent): void;
	igDoughnutChart(optionLiteral: 'option', optionName: "holeDimensionsChanged"): HoleDimensionsChangedEvent;
	igDoughnutChart(optionLiteral: 'option', optionName: "holeDimensionsChanged", optionValue: HoleDimensionsChangedEvent): void;
	igDoughnutChart(options: IgDoughnutChart): JQuery;
	igDoughnutChart(optionLiteral: 'option', optionName: string): any;
	igDoughnutChart(optionLiteral: 'option', options: IgDoughnutChart): JQuery;
	igDoughnutChart(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igDoughnutChart(methodName: string, ...methodParams: any[]): any;
}
interface KeydownEvent {
	(event: Event, ui: KeydownEventUIParam): void;
}

interface KeydownEventUIParam {
	owner?: any;
	key?: any;
}

interface KeypressEvent {
	(event: Event, ui: KeypressEventUIParam): void;
}

interface KeypressEventUIParam {
	owner?: any;
	key?: any;
}

interface KeyupEvent {
	(event: Event, ui: KeyupEventUIParam): void;
}

interface KeyupEventUIParam {
	owner?: any;
	key?: any;
}

interface MousedownEvent {
	(event: Event, ui: MousedownEventUIParam): void;
}

interface MousedownEventUIParam {
	owner?: any;
	elementType?: any;
	id?: any;
}

interface MouseupEvent {
	(event: Event, ui: MouseupEventUIParam): void;
}

interface MouseupEventUIParam {
	owner?: any;
	elementType?: any;
	id?: any;
}

interface MousemoveEvent {
	(event: Event, ui: MousemoveEventUIParam): void;
}

interface MousemoveEventUIParam {
	owner?: any;
	elementType?: any;
	id?: any;
}

interface MouseoverEvent {
	(event: Event, ui: MouseoverEventUIParam): void;
}

interface MouseoverEventUIParam {
	owner?: any;
	elementType?: any;
	id?: any;
}

interface MouseleaveEvent {
	(event: Event, ui: MouseleaveEventUIParam): void;
}

interface MouseleaveEventUIParam {
	owner?: any;
	elementType?: any;
	id?: any;
}

interface ValueChangingEvent {
	(event: Event, ui: ValueChangingEventUIParam): void;
}

interface ValueChangingEventUIParam {
	owner?: any;
	value?: any;
}

interface ValueChangedEvent {
	(event: Event, ui: ValueChangedEventUIParam): void;
}

interface ValueChangedEventUIParam {
	owner?: any;
	value?: any;
}

interface TextChangedEvent {
	(event: Event, ui: TextChangedEventUIParam): void;
}

interface TextChangedEventUIParam {
	owner?: any;
	text?: any;
}

interface InvalidValueEvent {
	(event: Event, ui: InvalidValueEventUIParam): void;
}

interface InvalidValueEventUIParam {
	owner?: any;
	value?: any;
}

interface SpinEvent {
	(event: Event, ui: SpinEventUIParam): void;
}

interface SpinEventUIParam {
	owner?: any;
	delta?: any;
	value?: any;
}

interface ButtonClickEvent {
	(event: Event, ui: ButtonClickEventUIParam): void;
}

interface ButtonClickEventUIParam {
	owner?: any;
}

interface ShowDropDownEvent {
	(event: Event, ui: ShowDropDownEventUIParam): void;
}

interface ShowDropDownEventUIParam {
	owner?: any;
}

interface HideDropDownEvent {
	(event: Event, ui: HideDropDownEventUIParam): void;
}

interface HideDropDownEventUIParam {
	owner?: any;
	value?: any;
}

interface ListSelectingEvent {
	(event: Event, ui: ListSelectingEventUIParam): void;
}

interface ListSelectingEventUIParam {
	owner?: any;
	index?: any;
	oldIndex?: any;
	item?: any;
}

interface ListSelectedEvent {
	(event: Event, ui: ListSelectedEventUIParam): void;
}

interface ListSelectedEventUIParam {
	owner?: any;
	index?: any;
	oldIndex?: any;
	item?: any;
}

interface IgEditor {
	value?: any;
	tabIndex?: number;
	nullText?: string;
	button?: any;
	textAlign?: any;
	listItems?: any[];
	theme?: string;
	type?: any;
	locale?: any;
	width?: number;
	height?: number;
	validatorOptions?: any;
	required?: boolean;
	display?: string;
	renderInContainer?: boolean;
	selectionOnFocus?: any;
	readOnly?: boolean;
	spinOnReadOnly?: boolean;
	focusOnSpin?: boolean;
	spinWrapAround?: boolean;
	hideEnterKey?: boolean;
	dropDownOnReadOnly?: boolean;
	dropDownTriggers?: any;
	listDropDownAsChild?: boolean;
	listWidth?: number;
	listMaxHeight?: number;
	listColumns?: number;
	animationShowDuration?: number;
	animationHideDuration?: number;
	inputName?: string;
	keydown?: KeydownEvent;
	keypress?: KeypressEvent;
	keyup?: KeyupEvent;
	mousedown?: MousedownEvent;
	mouseup?: MouseupEvent;
	mousemove?: MousemoveEvent;
	mouseover?: MouseoverEvent;
	mouseleave?: MouseleaveEvent;
	focus?: FocusEvent;
	blur?: BlurEvent;
	valueChanging?: ValueChangingEvent;
	valueChanged?: ValueChangedEvent;
	textChanged?: TextChangedEvent;
	invalidValue?: InvalidValueEvent;
	spin?: SpinEvent;
	buttonClick?: ButtonClickEvent;
	showDropDown?: ShowDropDownEvent;
	hideDropDown?: HideDropDownEvent;
	listSelecting?: ListSelectingEvent;
	listSelected?: ListSelectedEvent;
}
interface IgEditorMethods {
	validate(noLabel?: boolean): boolean;
	isValid(): boolean;
	getRegionalOption(name: string): string;
	field(): void;
	mainElement(): void;
	dropDownElement(): void;
	show(): Object;
	hide(): Object;
	remove(): Object;
	dropDownVisible(showHide?: boolean): void;
	findListItemIndex(text: string, ignoreCase?: boolean, partial?: boolean, contains?: boolean): number;
	addListItems(items: Object, index?: number): Object;
	addListItem(item: Object, index?: number): Object;
	removeListItem(item: Object): Object;
	removeListItemAt(index: number): Object;
	clearListItems(): Object;
	selectedListIndex(index?: number): number;
	getSelectedListItem(): void;
	hasInvalidMessage(): boolean;
	validator(): Object;
	text(val?: string, flag?: number): void;
	value(val?: Object): void;
	paste(txt: string, flag?: boolean): Object;
	select(sel0?: number, sel1?: number, val?: string): Object;
	getSelectedText(): string;
	getSelection(start?: boolean): number;
	setFocus(delay?: number): Object;
	hasFocus(): boolean;
	getValueByMode(mode: string, v?: Object, getVal?: Object): void;
	spin(delta: number): Object;
	destroy(): Object;
}
interface JQuery {
	data(propertyName: "igEditor"):IgEditorMethods;
}

interface IgTextEditor {
	textMode?: any;
	maxLength?: number;
	includeKeys?: string;
	excludeKeys?: string;
	toUpper?: boolean;
	toLower?: boolean;
	listMatchIgnoreCase?: boolean;
	listMatchOnly?: boolean;
	listMatchContains?: boolean;
	listAutoComplete?: boolean;
	value?: any;
	tabIndex?: number;
	nullText?: string;
	button?: any;
	textAlign?: any;
	listItems?: any[];
	theme?: string;
	type?: any;
	locale?: any;
	width?: number;
	height?: number;
	validatorOptions?: any;
	required?: boolean;
	display?: string;
	renderInContainer?: boolean;
	selectionOnFocus?: any;
	readOnly?: boolean;
	spinOnReadOnly?: boolean;
	focusOnSpin?: boolean;
	spinWrapAround?: boolean;
	hideEnterKey?: boolean;
	dropDownOnReadOnly?: boolean;
	dropDownTriggers?: any;
	listDropDownAsChild?: boolean;
	listWidth?: number;
	listMaxHeight?: number;
	listColumns?: number;
	animationShowDuration?: number;
	animationHideDuration?: number;
	inputName?: string;
	keydown?: KeydownEvent;
	keypress?: KeypressEvent;
	keyup?: KeyupEvent;
	mousedown?: MousedownEvent;
	mouseup?: MouseupEvent;
	mousemove?: MousemoveEvent;
	mouseover?: MouseoverEvent;
	mouseleave?: MouseleaveEvent;
	focus?: FocusEvent;
	blur?: BlurEvent;
	valueChanging?: ValueChangingEvent;
	valueChanged?: ValueChangedEvent;
	textChanged?: TextChangedEvent;
	invalidValue?: InvalidValueEvent;
	spin?: SpinEvent;
	buttonClick?: ButtonClickEvent;
	showDropDown?: ShowDropDownEvent;
	hideDropDown?: HideDropDownEvent;
	listSelecting?: ListSelectingEvent;
	listSelected?: ListSelectedEvent;
}
interface IgTextEditorMethods {
	validate(noLabel?: boolean): boolean;
	isValid(): boolean;
	getRegionalOption(name: string): string;
	field(): void;
	mainElement(): void;
	dropDownElement(): void;
	show(): Object;
	hide(): Object;
	remove(): Object;
	dropDownVisible(showHide?: boolean): void;
	findListItemIndex(text: string, ignoreCase?: boolean, partial?: boolean, contains?: boolean): number;
	addListItems(items: Object, index?: number): Object;
	addListItem(item: Object, index?: number): Object;
	removeListItem(item: Object): Object;
	removeListItemAt(index: number): Object;
	clearListItems(): Object;
	selectedListIndex(index?: number): number;
	getSelectedListItem(): void;
	hasInvalidMessage(): boolean;
	validator(): Object;
	text(val?: string, flag?: number): void;
	value(val?: Object): void;
	paste(txt: string, flag?: boolean): Object;
	select(sel0?: number, sel1?: number, val?: string): Object;
	getSelectedText(): string;
	getSelection(start?: boolean): number;
	setFocus(delay?: number): Object;
	hasFocus(): boolean;
	getValueByMode(mode: string, v?: Object, getVal?: Object): void;
	spin(delta: number): Object;
	destroy(): Object;
}
interface JQuery {
	data(propertyName: "igTextEditor"):IgTextEditorMethods;
}

interface IgMaskEditor {
	includeKeys?: string;
	excludeKeys?: string;
	toUpper?: boolean;
	toLower?: boolean;
	listMatchIgnoreCase?: boolean;
	listMatchOnly?: boolean;
	listMatchContains?: boolean;
	listAutoComplete?: boolean;
	inputMask?: string;
	promptChar?: string;
	padChar?: string;
	emptyChar?: string;
	dataMode?: any;
	hideMaskOnFocus?: boolean;
	value?: any;
	tabIndex?: number;
	nullText?: string;
	button?: any;
	textAlign?: any;
	listItems?: any[];
	theme?: string;
	type?: any;
	locale?: any;
	width?: number;
	height?: number;
	validatorOptions?: any;
	required?: boolean;
	display?: string;
	renderInContainer?: boolean;
	selectionOnFocus?: any;
	readOnly?: boolean;
	spinOnReadOnly?: boolean;
	focusOnSpin?: boolean;
	spinWrapAround?: boolean;
	hideEnterKey?: boolean;
	dropDownOnReadOnly?: boolean;
	dropDownTriggers?: any;
	listDropDownAsChild?: boolean;
	listWidth?: number;
	listMaxHeight?: number;
	listColumns?: number;
	animationShowDuration?: number;
	animationHideDuration?: number;
	inputName?: string;
	keydown?: KeydownEvent;
	keypress?: KeypressEvent;
	keyup?: KeyupEvent;
	mousedown?: MousedownEvent;
	mouseup?: MouseupEvent;
	mousemove?: MousemoveEvent;
	mouseover?: MouseoverEvent;
	mouseleave?: MouseleaveEvent;
	focus?: FocusEvent;
	blur?: BlurEvent;
	valueChanging?: ValueChangingEvent;
	valueChanged?: ValueChangedEvent;
	textChanged?: TextChangedEvent;
	invalidValue?: InvalidValueEvent;
	spin?: SpinEvent;
	buttonClick?: ButtonClickEvent;
	showDropDown?: ShowDropDownEvent;
	hideDropDown?: HideDropDownEvent;
	listSelecting?: ListSelectingEvent;
	listSelected?: ListSelectedEvent;
}
interface IgMaskEditorMethods {
	validate(noLabel?: boolean): boolean;
	isValid(): boolean;
	getRegionalOption(name: string): string;
	field(): void;
	mainElement(): void;
	dropDownElement(): void;
	show(): Object;
	hide(): Object;
	remove(): Object;
	dropDownVisible(showHide?: boolean): void;
	findListItemIndex(text: string, ignoreCase?: boolean, partial?: boolean, contains?: boolean): number;
	addListItems(items: Object, index?: number): Object;
	addListItem(item: Object, index?: number): Object;
	removeListItem(item: Object): Object;
	removeListItemAt(index: number): Object;
	clearListItems(): Object;
	selectedListIndex(index?: number): number;
	getSelectedListItem(): void;
	hasInvalidMessage(): boolean;
	validator(): Object;
	text(val?: string, flag?: number): void;
	value(val?: Object): void;
	paste(txt: string, flag?: boolean): Object;
	select(sel0?: number, sel1?: number, val?: string): Object;
	getSelectedText(): string;
	getSelection(start?: boolean): number;
	setFocus(delay?: number): Object;
	hasFocus(): boolean;
	getValueByMode(mode: string, v?: Object, getVal?: Object): void;
	spin(delta: number): Object;
	destroy(): Object;
}
interface JQuery {
	data(propertyName: "igMaskEditor"):IgMaskEditorMethods;
}

interface IgDateEditor {
	regional?: any;
	spin1Field?: boolean;
	minValue?: Object;
	maxValue?: Object;
	dateDisplayFormat?: string;
	dateInputFormat?: string;
	promptChar?: string;
	dataMode?: any;
	minNumberOfDateFields?: number;
	useLastGoodDate?: boolean;
	reduceDayOfInvalidDate?: boolean;
	hideMaskOnFocus?: boolean;
	centuryThreshold?: number;
	enableUTCDates?: boolean;
	spinDelta?: number;
	nullable?: boolean;
	yearShift?: number;
	value?: any;
	tabIndex?: number;
	nullText?: string;
	button?: any;
	textAlign?: any;
	listItems?: any[];
	theme?: string;
	type?: any;
	locale?: any;
	width?: number;
	height?: number;
	validatorOptions?: any;
	required?: boolean;
	display?: string;
	renderInContainer?: boolean;
	selectionOnFocus?: any;
	readOnly?: boolean;
	spinOnReadOnly?: boolean;
	focusOnSpin?: boolean;
	spinWrapAround?: boolean;
	hideEnterKey?: boolean;
	dropDownOnReadOnly?: boolean;
	dropDownTriggers?: any;
	listDropDownAsChild?: boolean;
	listWidth?: number;
	listMaxHeight?: number;
	listColumns?: number;
	animationShowDuration?: number;
	animationHideDuration?: number;
	inputName?: string;
	keydown?: KeydownEvent;
	keypress?: KeypressEvent;
	keyup?: KeyupEvent;
	mousedown?: MousedownEvent;
	mouseup?: MouseupEvent;
	mousemove?: MousemoveEvent;
	mouseover?: MouseoverEvent;
	mouseleave?: MouseleaveEvent;
	focus?: FocusEvent;
	blur?: BlurEvent;
	valueChanging?: ValueChangingEvent;
	valueChanged?: ValueChangedEvent;
	textChanged?: TextChangedEvent;
	invalidValue?: InvalidValueEvent;
	spin?: SpinEvent;
	buttonClick?: ButtonClickEvent;
	showDropDown?: ShowDropDownEvent;
	hideDropDown?: HideDropDownEvent;
	listSelecting?: ListSelectingEvent;
	listSelected?: ListSelectedEvent;
}
interface IgDateEditorMethods {
	validate(noLabel?: boolean): boolean;
	isValid(): boolean;
	getRegionalOption(name: string): string;
	field(): void;
	mainElement(): void;
	dropDownElement(): void;
	show(): Object;
	hide(): Object;
	remove(): Object;
	dropDownVisible(showHide?: boolean): void;
	findListItemIndex(text: string, ignoreCase?: boolean, partial?: boolean, contains?: boolean): number;
	addListItems(items: Object, index?: number): Object;
	addListItem(item: Object, index?: number): Object;
	removeListItem(item: Object): Object;
	removeListItemAt(index: number): Object;
	clearListItems(): Object;
	selectedListIndex(index?: number): number;
	getSelectedListItem(): void;
	hasInvalidMessage(): boolean;
	validator(): Object;
	text(val?: string, flag?: number): void;
	value(val?: Object): void;
	paste(txt: string, flag?: boolean): Object;
	select(sel0?: number, sel1?: number, val?: string): Object;
	getSelectedText(): string;
	getSelection(start?: boolean): number;
	setFocus(delay?: number): Object;
	hasFocus(): boolean;
	getValueByMode(mode: string, v?: Object, getVal?: Object): void;
	spin(delta: number): Object;
	destroy(): Object;
}
interface JQuery {
	data(propertyName: "igDateEditor"):IgDateEditorMethods;
}

interface IgDatePicker {
	button?: any;
	focusOnDropDownOpen?: boolean;
	datepickerOptions?: any;
	regional?: any;
	spin1Field?: boolean;
	minValue?: Object;
	maxValue?: Object;
	dateDisplayFormat?: string;
	dateInputFormat?: string;
	promptChar?: string;
	dataMode?: any;
	minNumberOfDateFields?: number;
	useLastGoodDate?: boolean;
	reduceDayOfInvalidDate?: boolean;
	hideMaskOnFocus?: boolean;
	centuryThreshold?: number;
	enableUTCDates?: boolean;
	spinDelta?: number;
	nullable?: boolean;
	yearShift?: number;
}

interface IgNumericEditor {
	regional?: any;
	negativePattern?: string;
	negativeSign?: string;
	decimalSeparator?: string;
	groupSeparator?: string;
	groups?: any;
	maxDecimals?: number;
	minDecimals?: number;
	minValue?: number;
	maxValue?: number;
	scientificFormat?: any;
	nullValue?: number;
	spinDelta?: number;
	nullable?: boolean;
	maxLength?: number;
	dataMode?: any;
	value?: any;
	tabIndex?: number;
	nullText?: string;
	button?: any;
	textAlign?: any;
	listItems?: any[];
	theme?: string;
	type?: any;
	locale?: any;
	width?: number;
	height?: number;
	validatorOptions?: any;
	required?: boolean;
	display?: string;
	renderInContainer?: boolean;
	selectionOnFocus?: any;
	readOnly?: boolean;
	spinOnReadOnly?: boolean;
	focusOnSpin?: boolean;
	spinWrapAround?: boolean;
	hideEnterKey?: boolean;
	dropDownOnReadOnly?: boolean;
	dropDownTriggers?: any;
	listDropDownAsChild?: boolean;
	listWidth?: number;
	listMaxHeight?: number;
	listColumns?: number;
	animationShowDuration?: number;
	animationHideDuration?: number;
	inputName?: string;
	keydown?: KeydownEvent;
	keypress?: KeypressEvent;
	keyup?: KeyupEvent;
	mousedown?: MousedownEvent;
	mouseup?: MouseupEvent;
	mousemove?: MousemoveEvent;
	mouseover?: MouseoverEvent;
	mouseleave?: MouseleaveEvent;
	focus?: FocusEvent;
	blur?: BlurEvent;
	valueChanging?: ValueChangingEvent;
	valueChanged?: ValueChangedEvent;
	textChanged?: TextChangedEvent;
	invalidValue?: InvalidValueEvent;
	spin?: SpinEvent;
	buttonClick?: ButtonClickEvent;
	showDropDown?: ShowDropDownEvent;
	hideDropDown?: HideDropDownEvent;
	listSelecting?: ListSelectingEvent;
	listSelected?: ListSelectedEvent;
}
interface IgNumericEditorMethods {
	validate(noLabel?: boolean): boolean;
	isValid(): boolean;
	getRegionalOption(name: string): string;
	field(): void;
	mainElement(): void;
	dropDownElement(): void;
	show(): Object;
	hide(): Object;
	remove(): Object;
	dropDownVisible(showHide?: boolean): void;
	findListItemIndex(text: string, ignoreCase?: boolean, partial?: boolean, contains?: boolean): number;
	addListItems(items: Object, index?: number): Object;
	addListItem(item: Object, index?: number): Object;
	removeListItem(item: Object): Object;
	removeListItemAt(index: number): Object;
	clearListItems(): Object;
	selectedListIndex(index?: number): number;
	getSelectedListItem(): void;
	hasInvalidMessage(): boolean;
	validator(): Object;
	text(val?: string, flag?: number): void;
	value(val?: Object): void;
	paste(txt: string, flag?: boolean): Object;
	select(sel0?: number, sel1?: number, val?: string): Object;
	getSelectedText(): string;
	getSelection(start?: boolean): number;
	setFocus(delay?: number): Object;
	hasFocus(): boolean;
	getValueByMode(mode: string, v?: Object, getVal?: Object): void;
	spin(delta: number): Object;
	destroy(): Object;
}
interface JQuery {
	data(propertyName: "igNumericEditor"):IgNumericEditorMethods;
}

interface IgCurrencyEditor {
	positivePattern?: string;
	negativePattern?: string;
	symbol?: string;
	regional?: any;
	negativePattern?: string;
	negativeSign?: string;
	decimalSeparator?: string;
	groupSeparator?: string;
	groups?: any;
	maxDecimals?: number;
	minDecimals?: number;
	minValue?: number;
	maxValue?: number;
	scientificFormat?: any;
	nullValue?: number;
	spinDelta?: number;
	nullable?: boolean;
	maxLength?: number;
	dataMode?: any;
}

interface IgPercentEditor {
	positivePattern?: string;
	negativePattern?: string;
	symbol?: string;
	displayFactor?: number;
	regional?: any;
	negativePattern?: string;
	negativeSign?: string;
	decimalSeparator?: string;
	groupSeparator?: string;
	groups?: any;
	maxDecimals?: number;
	minDecimals?: number;
	minValue?: number;
	maxValue?: number;
	scientificFormat?: any;
	nullValue?: number;
	spinDelta?: number;
	nullable?: boolean;
	maxLength?: number;
	dataMode?: any;
}

interface JQuery {
	igEditor(methodName: "validate", noLabel?: boolean): boolean;
	igEditor(methodName: "isValid"): boolean;
	igEditor(methodName: "getRegionalOption", name: string): string;
	igEditor(methodName: "field"): void;
	igEditor(methodName: "mainElement"): void;
	igEditor(methodName: "dropDownElement"): void;
	igEditor(methodName: "show"): Object;
	igEditor(methodName: "hide"): Object;
	igEditor(methodName: "remove"): Object;
	igEditor(methodName: "dropDownVisible", showHide?: boolean): void;
	igEditor(methodName: "findListItemIndex", text: string, ignoreCase?: boolean, partial?: boolean, contains?: boolean): number;
	igEditor(methodName: "addListItems", items: Object, index?: number): Object;
	igEditor(methodName: "addListItem", item: Object, index?: number): Object;
	igEditor(methodName: "removeListItem", item: Object): Object;
	igEditor(methodName: "removeListItemAt", index: number): Object;
	igEditor(methodName: "clearListItems"): Object;
	igEditor(methodName: "selectedListIndex", index?: number): number;
	igEditor(methodName: "getSelectedListItem"): void;
	igEditor(methodName: "hasInvalidMessage"): boolean;
	igEditor(methodName: "validator"): Object;
	igEditor(methodName: "text", val?: string, flag?: number): void;
	igEditor(methodName: "value", val?: Object): void;
	igEditor(methodName: "paste", txt: string, flag?: boolean): Object;
	igEditor(methodName: "select", sel0?: number, sel1?: number, val?: string): Object;
	igEditor(methodName: "getSelectedText"): string;
	igEditor(methodName: "getSelection", start?: boolean): number;
	igEditor(methodName: "setFocus", delay?: number): Object;
	igEditor(methodName: "hasFocus"): boolean;
	igEditor(methodName: "getValueByMode", mode: string, v?: Object, getVal?: Object): void;
	igEditor(methodName: "spin", delta: number): Object;
	igEditor(methodName: "destroy"): Object;
	igEditor(optionLiteral: 'option', optionName: "value"): any;
	igEditor(optionLiteral: 'option', optionName: "value", optionValue: any): void;
	igEditor(optionLiteral: 'option', optionName: "tabIndex"): number;
	igEditor(optionLiteral: 'option', optionName: "tabIndex", optionValue: number): void;
	igEditor(optionLiteral: 'option', optionName: "nullText"): string;
	igEditor(optionLiteral: 'option', optionName: "nullText", optionValue: string): void;
	igEditor(optionLiteral: 'option', optionName: "button"): any;
	igEditor(optionLiteral: 'option', optionName: "button", optionValue: any): void;
	igEditor(optionLiteral: 'option', optionName: "textAlign"): any;
	igEditor(optionLiteral: 'option', optionName: "textAlign", optionValue: any): void;
	igEditor(optionLiteral: 'option', optionName: "listItems"): any[];
	igEditor(optionLiteral: 'option', optionName: "listItems", optionValue: any[]): void;
	igEditor(optionLiteral: 'option', optionName: "theme"): string;
	igEditor(optionLiteral: 'option', optionName: "theme", optionValue: string): void;
	igEditor(optionLiteral: 'option', optionName: "type"): any;
	igEditor(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igEditor(optionLiteral: 'option', optionName: "locale"): any;
	igEditor(optionLiteral: 'option', optionName: "locale", optionValue: any): void;
	igEditor(optionLiteral: 'option', optionName: "width"): number;
	igEditor(optionLiteral: 'option', optionName: "width", optionValue: number): void;
	igEditor(optionLiteral: 'option', optionName: "height"): number;
	igEditor(optionLiteral: 'option', optionName: "height", optionValue: number): void;
	igEditor(optionLiteral: 'option', optionName: "validatorOptions"): any;
	igEditor(optionLiteral: 'option', optionName: "validatorOptions", optionValue: any): void;
	igEditor(optionLiteral: 'option', optionName: "required"): boolean;
	igEditor(optionLiteral: 'option', optionName: "required", optionValue: boolean): void;
	igEditor(optionLiteral: 'option', optionName: "display"): string;
	igEditor(optionLiteral: 'option', optionName: "display", optionValue: string): void;
	igEditor(optionLiteral: 'option', optionName: "renderInContainer"): boolean;
	igEditor(optionLiteral: 'option', optionName: "renderInContainer", optionValue: boolean): void;
	igEditor(optionLiteral: 'option', optionName: "selectionOnFocus"): any;
	igEditor(optionLiteral: 'option', optionName: "selectionOnFocus", optionValue: any): void;
	igEditor(optionLiteral: 'option', optionName: "readOnly"): boolean;
	igEditor(optionLiteral: 'option', optionName: "readOnly", optionValue: boolean): void;
	igEditor(optionLiteral: 'option', optionName: "spinOnReadOnly"): boolean;
	igEditor(optionLiteral: 'option', optionName: "spinOnReadOnly", optionValue: boolean): void;
	igEditor(optionLiteral: 'option', optionName: "focusOnSpin"): boolean;
	igEditor(optionLiteral: 'option', optionName: "focusOnSpin", optionValue: boolean): void;
	igEditor(optionLiteral: 'option', optionName: "spinWrapAround"): boolean;
	igEditor(optionLiteral: 'option', optionName: "spinWrapAround", optionValue: boolean): void;
	igEditor(optionLiteral: 'option', optionName: "hideEnterKey"): boolean;
	igEditor(optionLiteral: 'option', optionName: "hideEnterKey", optionValue: boolean): void;
	igEditor(optionLiteral: 'option', optionName: "dropDownOnReadOnly"): boolean;
	igEditor(optionLiteral: 'option', optionName: "dropDownOnReadOnly", optionValue: boolean): void;
	igEditor(optionLiteral: 'option', optionName: "dropDownTriggers"): any;
	igEditor(optionLiteral: 'option', optionName: "dropDownTriggers", optionValue: any): void;
	igEditor(optionLiteral: 'option', optionName: "listDropDownAsChild"): boolean;
	igEditor(optionLiteral: 'option', optionName: "listDropDownAsChild", optionValue: boolean): void;
	igEditor(optionLiteral: 'option', optionName: "listWidth"): number;
	igEditor(optionLiteral: 'option', optionName: "listWidth", optionValue: number): void;
	igEditor(optionLiteral: 'option', optionName: "listMaxHeight"): number;
	igEditor(optionLiteral: 'option', optionName: "listMaxHeight", optionValue: number): void;
	igEditor(optionLiteral: 'option', optionName: "listColumns"): number;
	igEditor(optionLiteral: 'option', optionName: "listColumns", optionValue: number): void;
	igEditor(optionLiteral: 'option', optionName: "animationShowDuration"): number;
	igEditor(optionLiteral: 'option', optionName: "animationShowDuration", optionValue: number): void;
	igEditor(optionLiteral: 'option', optionName: "animationHideDuration"): number;
	igEditor(optionLiteral: 'option', optionName: "animationHideDuration", optionValue: number): void;
	igEditor(optionLiteral: 'option', optionName: "inputName"): string;
	igEditor(optionLiteral: 'option', optionName: "inputName", optionValue: string): void;
	igEditor(optionLiteral: 'option', optionName: "keydown"): KeydownEvent;
	igEditor(optionLiteral: 'option', optionName: "keydown", optionValue: KeydownEvent): void;
	igEditor(optionLiteral: 'option', optionName: "keypress"): KeypressEvent;
	igEditor(optionLiteral: 'option', optionName: "keypress", optionValue: KeypressEvent): void;
	igEditor(optionLiteral: 'option', optionName: "keyup"): KeyupEvent;
	igEditor(optionLiteral: 'option', optionName: "keyup", optionValue: KeyupEvent): void;
	igEditor(optionLiteral: 'option', optionName: "mousedown"): MousedownEvent;
	igEditor(optionLiteral: 'option', optionName: "mousedown", optionValue: MousedownEvent): void;
	igEditor(optionLiteral: 'option', optionName: "mouseup"): MouseupEvent;
	igEditor(optionLiteral: 'option', optionName: "mouseup", optionValue: MouseupEvent): void;
	igEditor(optionLiteral: 'option', optionName: "mousemove"): MousemoveEvent;
	igEditor(optionLiteral: 'option', optionName: "mousemove", optionValue: MousemoveEvent): void;
	igEditor(optionLiteral: 'option', optionName: "mouseover"): MouseoverEvent;
	igEditor(optionLiteral: 'option', optionName: "mouseover", optionValue: MouseoverEvent): void;
	igEditor(optionLiteral: 'option', optionName: "mouseleave"): MouseleaveEvent;
	igEditor(optionLiteral: 'option', optionName: "mouseleave", optionValue: MouseleaveEvent): void;
	igEditor(optionLiteral: 'option', optionName: "focus"): FocusEvent;
	igEditor(optionLiteral: 'option', optionName: "focus", optionValue: FocusEvent): void;
	igEditor(optionLiteral: 'option', optionName: "blur"): BlurEvent;
	igEditor(optionLiteral: 'option', optionName: "blur", optionValue: BlurEvent): void;
	igEditor(optionLiteral: 'option', optionName: "valueChanging"): ValueChangingEvent;
	igEditor(optionLiteral: 'option', optionName: "valueChanging", optionValue: ValueChangingEvent): void;
	igEditor(optionLiteral: 'option', optionName: "valueChanged"): ValueChangedEvent;
	igEditor(optionLiteral: 'option', optionName: "valueChanged", optionValue: ValueChangedEvent): void;
	igEditor(optionLiteral: 'option', optionName: "textChanged"): TextChangedEvent;
	igEditor(optionLiteral: 'option', optionName: "textChanged", optionValue: TextChangedEvent): void;
	igEditor(optionLiteral: 'option', optionName: "invalidValue"): InvalidValueEvent;
	igEditor(optionLiteral: 'option', optionName: "invalidValue", optionValue: InvalidValueEvent): void;
	igEditor(optionLiteral: 'option', optionName: "spin"): SpinEvent;
	igEditor(optionLiteral: 'option', optionName: "spin", optionValue: SpinEvent): void;
	igEditor(optionLiteral: 'option', optionName: "buttonClick"): ButtonClickEvent;
	igEditor(optionLiteral: 'option', optionName: "buttonClick", optionValue: ButtonClickEvent): void;
	igEditor(optionLiteral: 'option', optionName: "showDropDown"): ShowDropDownEvent;
	igEditor(optionLiteral: 'option', optionName: "showDropDown", optionValue: ShowDropDownEvent): void;
	igEditor(optionLiteral: 'option', optionName: "hideDropDown"): HideDropDownEvent;
	igEditor(optionLiteral: 'option', optionName: "hideDropDown", optionValue: HideDropDownEvent): void;
	igEditor(optionLiteral: 'option', optionName: "listSelecting"): ListSelectingEvent;
	igEditor(optionLiteral: 'option', optionName: "listSelecting", optionValue: ListSelectingEvent): void;
	igEditor(optionLiteral: 'option', optionName: "listSelected"): ListSelectedEvent;
	igEditor(optionLiteral: 'option', optionName: "listSelected", optionValue: ListSelectedEvent): void;
	igEditor(options: IgEditor): JQuery;
	igEditor(optionLiteral: 'option', optionName: string): any;
	igEditor(optionLiteral: 'option', options: IgEditor): JQuery;
	igEditor(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igEditor(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igTextEditor(methodName: "validate", noLabel?: boolean): boolean;
	igTextEditor(methodName: "isValid"): boolean;
	igTextEditor(methodName: "getRegionalOption", name: string): string;
	igTextEditor(methodName: "field"): void;
	igTextEditor(methodName: "mainElement"): void;
	igTextEditor(methodName: "dropDownElement"): void;
	igTextEditor(methodName: "show"): Object;
	igTextEditor(methodName: "hide"): Object;
	igTextEditor(methodName: "remove"): Object;
	igTextEditor(methodName: "dropDownVisible", showHide?: boolean): void;
	igTextEditor(methodName: "findListItemIndex", text: string, ignoreCase?: boolean, partial?: boolean, contains?: boolean): number;
	igTextEditor(methodName: "addListItems", items: Object, index?: number): Object;
	igTextEditor(methodName: "addListItem", item: Object, index?: number): Object;
	igTextEditor(methodName: "removeListItem", item: Object): Object;
	igTextEditor(methodName: "removeListItemAt", index: number): Object;
	igTextEditor(methodName: "clearListItems"): Object;
	igTextEditor(methodName: "selectedListIndex", index?: number): number;
	igTextEditor(methodName: "getSelectedListItem"): void;
	igTextEditor(methodName: "hasInvalidMessage"): boolean;
	igTextEditor(methodName: "validator"): Object;
	igTextEditor(methodName: "text", val?: string, flag?: number): void;
	igTextEditor(methodName: "value", val?: Object): void;
	igTextEditor(methodName: "paste", txt: string, flag?: boolean): Object;
	igTextEditor(methodName: "select", sel0?: number, sel1?: number, val?: string): Object;
	igTextEditor(methodName: "getSelectedText"): string;
	igTextEditor(methodName: "getSelection", start?: boolean): number;
	igTextEditor(methodName: "setFocus", delay?: number): Object;
	igTextEditor(methodName: "hasFocus"): boolean;
	igTextEditor(methodName: "getValueByMode", mode: string, v?: Object, getVal?: Object): void;
	igTextEditor(methodName: "spin", delta: number): Object;
	igTextEditor(methodName: "destroy"): Object;
	igTextEditor(optionLiteral: 'option', optionName: "textMode"): any;
	igTextEditor(optionLiteral: 'option', optionName: "textMode", optionValue: any): void;
	igTextEditor(optionLiteral: 'option', optionName: "maxLength"): number;
	igTextEditor(optionLiteral: 'option', optionName: "maxLength", optionValue: number): void;
	igTextEditor(optionLiteral: 'option', optionName: "includeKeys"): string;
	igTextEditor(optionLiteral: 'option', optionName: "includeKeys", optionValue: string): void;
	igTextEditor(optionLiteral: 'option', optionName: "excludeKeys"): string;
	igTextEditor(optionLiteral: 'option', optionName: "excludeKeys", optionValue: string): void;
	igTextEditor(optionLiteral: 'option', optionName: "toUpper"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "toUpper", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "toLower"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "toLower", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "listMatchIgnoreCase"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "listMatchIgnoreCase", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "listMatchOnly"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "listMatchOnly", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "listMatchContains"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "listMatchContains", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "listAutoComplete"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "listAutoComplete", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "value"): any;
	igTextEditor(optionLiteral: 'option', optionName: "value", optionValue: any): void;
	igTextEditor(optionLiteral: 'option', optionName: "tabIndex"): number;
	igTextEditor(optionLiteral: 'option', optionName: "tabIndex", optionValue: number): void;
	igTextEditor(optionLiteral: 'option', optionName: "nullText"): string;
	igTextEditor(optionLiteral: 'option', optionName: "nullText", optionValue: string): void;
	igTextEditor(optionLiteral: 'option', optionName: "button"): any;
	igTextEditor(optionLiteral: 'option', optionName: "button", optionValue: any): void;
	igTextEditor(optionLiteral: 'option', optionName: "textAlign"): any;
	igTextEditor(optionLiteral: 'option', optionName: "textAlign", optionValue: any): void;
	igTextEditor(optionLiteral: 'option', optionName: "listItems"): any[];
	igTextEditor(optionLiteral: 'option', optionName: "listItems", optionValue: any[]): void;
	igTextEditor(optionLiteral: 'option', optionName: "theme"): string;
	igTextEditor(optionLiteral: 'option', optionName: "theme", optionValue: string): void;
	igTextEditor(optionLiteral: 'option', optionName: "type"): any;
	igTextEditor(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igTextEditor(optionLiteral: 'option', optionName: "locale"): any;
	igTextEditor(optionLiteral: 'option', optionName: "locale", optionValue: any): void;
	igTextEditor(optionLiteral: 'option', optionName: "width"): number;
	igTextEditor(optionLiteral: 'option', optionName: "width", optionValue: number): void;
	igTextEditor(optionLiteral: 'option', optionName: "height"): number;
	igTextEditor(optionLiteral: 'option', optionName: "height", optionValue: number): void;
	igTextEditor(optionLiteral: 'option', optionName: "validatorOptions"): any;
	igTextEditor(optionLiteral: 'option', optionName: "validatorOptions", optionValue: any): void;
	igTextEditor(optionLiteral: 'option', optionName: "required"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "required", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "display"): string;
	igTextEditor(optionLiteral: 'option', optionName: "display", optionValue: string): void;
	igTextEditor(optionLiteral: 'option', optionName: "renderInContainer"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "renderInContainer", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "selectionOnFocus"): any;
	igTextEditor(optionLiteral: 'option', optionName: "selectionOnFocus", optionValue: any): void;
	igTextEditor(optionLiteral: 'option', optionName: "readOnly"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "readOnly", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "spinOnReadOnly"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "spinOnReadOnly", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "focusOnSpin"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "focusOnSpin", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "spinWrapAround"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "spinWrapAround", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "hideEnterKey"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "hideEnterKey", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "dropDownOnReadOnly"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "dropDownOnReadOnly", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "dropDownTriggers"): any;
	igTextEditor(optionLiteral: 'option', optionName: "dropDownTriggers", optionValue: any): void;
	igTextEditor(optionLiteral: 'option', optionName: "listDropDownAsChild"): boolean;
	igTextEditor(optionLiteral: 'option', optionName: "listDropDownAsChild", optionValue: boolean): void;
	igTextEditor(optionLiteral: 'option', optionName: "listWidth"): number;
	igTextEditor(optionLiteral: 'option', optionName: "listWidth", optionValue: number): void;
	igTextEditor(optionLiteral: 'option', optionName: "listMaxHeight"): number;
	igTextEditor(optionLiteral: 'option', optionName: "listMaxHeight", optionValue: number): void;
	igTextEditor(optionLiteral: 'option', optionName: "listColumns"): number;
	igTextEditor(optionLiteral: 'option', optionName: "listColumns", optionValue: number): void;
	igTextEditor(optionLiteral: 'option', optionName: "animationShowDuration"): number;
	igTextEditor(optionLiteral: 'option', optionName: "animationShowDuration", optionValue: number): void;
	igTextEditor(optionLiteral: 'option', optionName: "animationHideDuration"): number;
	igTextEditor(optionLiteral: 'option', optionName: "animationHideDuration", optionValue: number): void;
	igTextEditor(optionLiteral: 'option', optionName: "inputName"): string;
	igTextEditor(optionLiteral: 'option', optionName: "inputName", optionValue: string): void;
	igTextEditor(optionLiteral: 'option', optionName: "keydown"): KeydownEvent;
	igTextEditor(optionLiteral: 'option', optionName: "keydown", optionValue: KeydownEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "keypress"): KeypressEvent;
	igTextEditor(optionLiteral: 'option', optionName: "keypress", optionValue: KeypressEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "keyup"): KeyupEvent;
	igTextEditor(optionLiteral: 'option', optionName: "keyup", optionValue: KeyupEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "mousedown"): MousedownEvent;
	igTextEditor(optionLiteral: 'option', optionName: "mousedown", optionValue: MousedownEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "mouseup"): MouseupEvent;
	igTextEditor(optionLiteral: 'option', optionName: "mouseup", optionValue: MouseupEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "mousemove"): MousemoveEvent;
	igTextEditor(optionLiteral: 'option', optionName: "mousemove", optionValue: MousemoveEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "mouseover"): MouseoverEvent;
	igTextEditor(optionLiteral: 'option', optionName: "mouseover", optionValue: MouseoverEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "mouseleave"): MouseleaveEvent;
	igTextEditor(optionLiteral: 'option', optionName: "mouseleave", optionValue: MouseleaveEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "focus"): FocusEvent;
	igTextEditor(optionLiteral: 'option', optionName: "focus", optionValue: FocusEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "blur"): BlurEvent;
	igTextEditor(optionLiteral: 'option', optionName: "blur", optionValue: BlurEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "valueChanging"): ValueChangingEvent;
	igTextEditor(optionLiteral: 'option', optionName: "valueChanging", optionValue: ValueChangingEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "valueChanged"): ValueChangedEvent;
	igTextEditor(optionLiteral: 'option', optionName: "valueChanged", optionValue: ValueChangedEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "textChanged"): TextChangedEvent;
	igTextEditor(optionLiteral: 'option', optionName: "textChanged", optionValue: TextChangedEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "invalidValue"): InvalidValueEvent;
	igTextEditor(optionLiteral: 'option', optionName: "invalidValue", optionValue: InvalidValueEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "spin"): SpinEvent;
	igTextEditor(optionLiteral: 'option', optionName: "spin", optionValue: SpinEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "buttonClick"): ButtonClickEvent;
	igTextEditor(optionLiteral: 'option', optionName: "buttonClick", optionValue: ButtonClickEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "showDropDown"): ShowDropDownEvent;
	igTextEditor(optionLiteral: 'option', optionName: "showDropDown", optionValue: ShowDropDownEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "hideDropDown"): HideDropDownEvent;
	igTextEditor(optionLiteral: 'option', optionName: "hideDropDown", optionValue: HideDropDownEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "listSelecting"): ListSelectingEvent;
	igTextEditor(optionLiteral: 'option', optionName: "listSelecting", optionValue: ListSelectingEvent): void;
	igTextEditor(optionLiteral: 'option', optionName: "listSelected"): ListSelectedEvent;
	igTextEditor(optionLiteral: 'option', optionName: "listSelected", optionValue: ListSelectedEvent): void;
	igTextEditor(options: IgTextEditor): JQuery;
	igTextEditor(optionLiteral: 'option', optionName: string): any;
	igTextEditor(optionLiteral: 'option', options: IgTextEditor): JQuery;
	igTextEditor(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTextEditor(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igMaskEditor(methodName: "validate", noLabel?: boolean): boolean;
	igMaskEditor(methodName: "isValid"): boolean;
	igMaskEditor(methodName: "getRegionalOption", name: string): string;
	igMaskEditor(methodName: "field"): void;
	igMaskEditor(methodName: "mainElement"): void;
	igMaskEditor(methodName: "dropDownElement"): void;
	igMaskEditor(methodName: "show"): Object;
	igMaskEditor(methodName: "hide"): Object;
	igMaskEditor(methodName: "remove"): Object;
	igMaskEditor(methodName: "dropDownVisible", showHide?: boolean): void;
	igMaskEditor(methodName: "findListItemIndex", text: string, ignoreCase?: boolean, partial?: boolean, contains?: boolean): number;
	igMaskEditor(methodName: "addListItems", items: Object, index?: number): Object;
	igMaskEditor(methodName: "addListItem", item: Object, index?: number): Object;
	igMaskEditor(methodName: "removeListItem", item: Object): Object;
	igMaskEditor(methodName: "removeListItemAt", index: number): Object;
	igMaskEditor(methodName: "clearListItems"): Object;
	igMaskEditor(methodName: "selectedListIndex", index?: number): number;
	igMaskEditor(methodName: "getSelectedListItem"): void;
	igMaskEditor(methodName: "hasInvalidMessage"): boolean;
	igMaskEditor(methodName: "validator"): Object;
	igMaskEditor(methodName: "text", val?: string, flag?: number): void;
	igMaskEditor(methodName: "value", val?: Object): void;
	igMaskEditor(methodName: "paste", txt: string, flag?: boolean): Object;
	igMaskEditor(methodName: "select", sel0?: number, sel1?: number, val?: string): Object;
	igMaskEditor(methodName: "getSelectedText"): string;
	igMaskEditor(methodName: "getSelection", start?: boolean): number;
	igMaskEditor(methodName: "setFocus", delay?: number): Object;
	igMaskEditor(methodName: "hasFocus"): boolean;
	igMaskEditor(methodName: "getValueByMode", mode: string, v?: Object, getVal?: Object): void;
	igMaskEditor(methodName: "spin", delta: number): Object;
	igMaskEditor(methodName: "destroy"): Object;
	igMaskEditor(optionLiteral: 'option', optionName: "includeKeys"): string;
	igMaskEditor(optionLiteral: 'option', optionName: "includeKeys", optionValue: string): void;
	igMaskEditor(optionLiteral: 'option', optionName: "excludeKeys"): string;
	igMaskEditor(optionLiteral: 'option', optionName: "excludeKeys", optionValue: string): void;
	igMaskEditor(optionLiteral: 'option', optionName: "toUpper"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "toUpper", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "toLower"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "toLower", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "listMatchIgnoreCase"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "listMatchIgnoreCase", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "listMatchOnly"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "listMatchOnly", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "listMatchContains"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "listMatchContains", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "listAutoComplete"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "listAutoComplete", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "inputMask"): string;
	igMaskEditor(optionLiteral: 'option', optionName: "inputMask", optionValue: string): void;
	igMaskEditor(optionLiteral: 'option', optionName: "promptChar"): string;
	igMaskEditor(optionLiteral: 'option', optionName: "promptChar", optionValue: string): void;
	igMaskEditor(optionLiteral: 'option', optionName: "padChar"): string;
	igMaskEditor(optionLiteral: 'option', optionName: "padChar", optionValue: string): void;
	igMaskEditor(optionLiteral: 'option', optionName: "emptyChar"): string;
	igMaskEditor(optionLiteral: 'option', optionName: "emptyChar", optionValue: string): void;
	igMaskEditor(optionLiteral: 'option', optionName: "dataMode"): any;
	igMaskEditor(optionLiteral: 'option', optionName: "dataMode", optionValue: any): void;
	igMaskEditor(optionLiteral: 'option', optionName: "hideMaskOnFocus"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "hideMaskOnFocus", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "value"): any;
	igMaskEditor(optionLiteral: 'option', optionName: "value", optionValue: any): void;
	igMaskEditor(optionLiteral: 'option', optionName: "tabIndex"): number;
	igMaskEditor(optionLiteral: 'option', optionName: "tabIndex", optionValue: number): void;
	igMaskEditor(optionLiteral: 'option', optionName: "nullText"): string;
	igMaskEditor(optionLiteral: 'option', optionName: "nullText", optionValue: string): void;
	igMaskEditor(optionLiteral: 'option', optionName: "button"): any;
	igMaskEditor(optionLiteral: 'option', optionName: "button", optionValue: any): void;
	igMaskEditor(optionLiteral: 'option', optionName: "textAlign"): any;
	igMaskEditor(optionLiteral: 'option', optionName: "textAlign", optionValue: any): void;
	igMaskEditor(optionLiteral: 'option', optionName: "listItems"): any[];
	igMaskEditor(optionLiteral: 'option', optionName: "listItems", optionValue: any[]): void;
	igMaskEditor(optionLiteral: 'option', optionName: "theme"): string;
	igMaskEditor(optionLiteral: 'option', optionName: "theme", optionValue: string): void;
	igMaskEditor(optionLiteral: 'option', optionName: "type"): any;
	igMaskEditor(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igMaskEditor(optionLiteral: 'option', optionName: "locale"): any;
	igMaskEditor(optionLiteral: 'option', optionName: "locale", optionValue: any): void;
	igMaskEditor(optionLiteral: 'option', optionName: "width"): number;
	igMaskEditor(optionLiteral: 'option', optionName: "width", optionValue: number): void;
	igMaskEditor(optionLiteral: 'option', optionName: "height"): number;
	igMaskEditor(optionLiteral: 'option', optionName: "height", optionValue: number): void;
	igMaskEditor(optionLiteral: 'option', optionName: "validatorOptions"): any;
	igMaskEditor(optionLiteral: 'option', optionName: "validatorOptions", optionValue: any): void;
	igMaskEditor(optionLiteral: 'option', optionName: "required"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "required", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "display"): string;
	igMaskEditor(optionLiteral: 'option', optionName: "display", optionValue: string): void;
	igMaskEditor(optionLiteral: 'option', optionName: "renderInContainer"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "renderInContainer", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "selectionOnFocus"): any;
	igMaskEditor(optionLiteral: 'option', optionName: "selectionOnFocus", optionValue: any): void;
	igMaskEditor(optionLiteral: 'option', optionName: "readOnly"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "readOnly", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "spinOnReadOnly"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "spinOnReadOnly", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "focusOnSpin"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "focusOnSpin", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "spinWrapAround"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "spinWrapAround", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "hideEnterKey"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "hideEnterKey", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "dropDownOnReadOnly"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "dropDownOnReadOnly", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "dropDownTriggers"): any;
	igMaskEditor(optionLiteral: 'option', optionName: "dropDownTriggers", optionValue: any): void;
	igMaskEditor(optionLiteral: 'option', optionName: "listDropDownAsChild"): boolean;
	igMaskEditor(optionLiteral: 'option', optionName: "listDropDownAsChild", optionValue: boolean): void;
	igMaskEditor(optionLiteral: 'option', optionName: "listWidth"): number;
	igMaskEditor(optionLiteral: 'option', optionName: "listWidth", optionValue: number): void;
	igMaskEditor(optionLiteral: 'option', optionName: "listMaxHeight"): number;
	igMaskEditor(optionLiteral: 'option', optionName: "listMaxHeight", optionValue: number): void;
	igMaskEditor(optionLiteral: 'option', optionName: "listColumns"): number;
	igMaskEditor(optionLiteral: 'option', optionName: "listColumns", optionValue: number): void;
	igMaskEditor(optionLiteral: 'option', optionName: "animationShowDuration"): number;
	igMaskEditor(optionLiteral: 'option', optionName: "animationShowDuration", optionValue: number): void;
	igMaskEditor(optionLiteral: 'option', optionName: "animationHideDuration"): number;
	igMaskEditor(optionLiteral: 'option', optionName: "animationHideDuration", optionValue: number): void;
	igMaskEditor(optionLiteral: 'option', optionName: "inputName"): string;
	igMaskEditor(optionLiteral: 'option', optionName: "inputName", optionValue: string): void;
	igMaskEditor(optionLiteral: 'option', optionName: "keydown"): KeydownEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "keydown", optionValue: KeydownEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "keypress"): KeypressEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "keypress", optionValue: KeypressEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "keyup"): KeyupEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "keyup", optionValue: KeyupEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "mousedown"): MousedownEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "mousedown", optionValue: MousedownEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "mouseup"): MouseupEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "mouseup", optionValue: MouseupEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "mousemove"): MousemoveEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "mousemove", optionValue: MousemoveEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "mouseover"): MouseoverEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "mouseover", optionValue: MouseoverEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "mouseleave"): MouseleaveEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "mouseleave", optionValue: MouseleaveEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "focus"): FocusEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "focus", optionValue: FocusEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "blur"): BlurEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "blur", optionValue: BlurEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "valueChanging"): ValueChangingEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "valueChanging", optionValue: ValueChangingEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "valueChanged"): ValueChangedEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "valueChanged", optionValue: ValueChangedEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "textChanged"): TextChangedEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "textChanged", optionValue: TextChangedEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "invalidValue"): InvalidValueEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "invalidValue", optionValue: InvalidValueEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "spin"): SpinEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "spin", optionValue: SpinEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "buttonClick"): ButtonClickEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "buttonClick", optionValue: ButtonClickEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "showDropDown"): ShowDropDownEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "showDropDown", optionValue: ShowDropDownEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "hideDropDown"): HideDropDownEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "hideDropDown", optionValue: HideDropDownEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "listSelecting"): ListSelectingEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "listSelecting", optionValue: ListSelectingEvent): void;
	igMaskEditor(optionLiteral: 'option', optionName: "listSelected"): ListSelectedEvent;
	igMaskEditor(optionLiteral: 'option', optionName: "listSelected", optionValue: ListSelectedEvent): void;
	igMaskEditor(options: IgMaskEditor): JQuery;
	igMaskEditor(optionLiteral: 'option', optionName: string): any;
	igMaskEditor(optionLiteral: 'option', options: IgMaskEditor): JQuery;
	igMaskEditor(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igMaskEditor(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igDateEditor(methodName: "validate", noLabel?: boolean): boolean;
	igDateEditor(methodName: "isValid"): boolean;
	igDateEditor(methodName: "getRegionalOption", name: string): string;
	igDateEditor(methodName: "field"): void;
	igDateEditor(methodName: "mainElement"): void;
	igDateEditor(methodName: "dropDownElement"): void;
	igDateEditor(methodName: "show"): Object;
	igDateEditor(methodName: "hide"): Object;
	igDateEditor(methodName: "remove"): Object;
	igDateEditor(methodName: "dropDownVisible", showHide?: boolean): void;
	igDateEditor(methodName: "findListItemIndex", text: string, ignoreCase?: boolean, partial?: boolean, contains?: boolean): number;
	igDateEditor(methodName: "addListItems", items: Object, index?: number): Object;
	igDateEditor(methodName: "addListItem", item: Object, index?: number): Object;
	igDateEditor(methodName: "removeListItem", item: Object): Object;
	igDateEditor(methodName: "removeListItemAt", index: number): Object;
	igDateEditor(methodName: "clearListItems"): Object;
	igDateEditor(methodName: "selectedListIndex", index?: number): number;
	igDateEditor(methodName: "getSelectedListItem"): void;
	igDateEditor(methodName: "hasInvalidMessage"): boolean;
	igDateEditor(methodName: "validator"): Object;
	igDateEditor(methodName: "text", val?: string, flag?: number): void;
	igDateEditor(methodName: "value", val?: Object): void;
	igDateEditor(methodName: "paste", txt: string, flag?: boolean): Object;
	igDateEditor(methodName: "select", sel0?: number, sel1?: number, val?: string): Object;
	igDateEditor(methodName: "getSelectedText"): string;
	igDateEditor(methodName: "getSelection", start?: boolean): number;
	igDateEditor(methodName: "setFocus", delay?: number): Object;
	igDateEditor(methodName: "hasFocus"): boolean;
	igDateEditor(methodName: "getValueByMode", mode: string, v?: Object, getVal?: Object): void;
	igDateEditor(methodName: "spin", delta: number): Object;
	igDateEditor(methodName: "destroy"): Object;
	igDateEditor(optionLiteral: 'option', optionName: "regional"): any;
	igDateEditor(optionLiteral: 'option', optionName: "regional", optionValue: any): void;
	igDateEditor(optionLiteral: 'option', optionName: "spin1Field"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "spin1Field", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "minValue"): Object;
	igDateEditor(optionLiteral: 'option', optionName: "minValue", optionValue: Object): void;
	igDateEditor(optionLiteral: 'option', optionName: "maxValue"): Object;
	igDateEditor(optionLiteral: 'option', optionName: "maxValue", optionValue: Object): void;
	igDateEditor(optionLiteral: 'option', optionName: "dateDisplayFormat"): string;
	igDateEditor(optionLiteral: 'option', optionName: "dateDisplayFormat", optionValue: string): void;
	igDateEditor(optionLiteral: 'option', optionName: "dateInputFormat"): string;
	igDateEditor(optionLiteral: 'option', optionName: "dateInputFormat", optionValue: string): void;
	igDateEditor(optionLiteral: 'option', optionName: "promptChar"): string;
	igDateEditor(optionLiteral: 'option', optionName: "promptChar", optionValue: string): void;
	igDateEditor(optionLiteral: 'option', optionName: "dataMode"): any;
	igDateEditor(optionLiteral: 'option', optionName: "dataMode", optionValue: any): void;
	igDateEditor(optionLiteral: 'option', optionName: "minNumberOfDateFields"): number;
	igDateEditor(optionLiteral: 'option', optionName: "minNumberOfDateFields", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "useLastGoodDate"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "useLastGoodDate", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "reduceDayOfInvalidDate"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "reduceDayOfInvalidDate", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "hideMaskOnFocus"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "hideMaskOnFocus", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "centuryThreshold"): number;
	igDateEditor(optionLiteral: 'option', optionName: "centuryThreshold", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "enableUTCDates"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "enableUTCDates", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "spinDelta"): number;
	igDateEditor(optionLiteral: 'option', optionName: "spinDelta", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "nullable"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "nullable", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "yearShift"): number;
	igDateEditor(optionLiteral: 'option', optionName: "yearShift", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "value"): any;
	igDateEditor(optionLiteral: 'option', optionName: "value", optionValue: any): void;
	igDateEditor(optionLiteral: 'option', optionName: "tabIndex"): number;
	igDateEditor(optionLiteral: 'option', optionName: "tabIndex", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "nullText"): string;
	igDateEditor(optionLiteral: 'option', optionName: "nullText", optionValue: string): void;
	igDateEditor(optionLiteral: 'option', optionName: "button"): any;
	igDateEditor(optionLiteral: 'option', optionName: "button", optionValue: any): void;
	igDateEditor(optionLiteral: 'option', optionName: "textAlign"): any;
	igDateEditor(optionLiteral: 'option', optionName: "textAlign", optionValue: any): void;
	igDateEditor(optionLiteral: 'option', optionName: "listItems"): any[];
	igDateEditor(optionLiteral: 'option', optionName: "listItems", optionValue: any[]): void;
	igDateEditor(optionLiteral: 'option', optionName: "theme"): string;
	igDateEditor(optionLiteral: 'option', optionName: "theme", optionValue: string): void;
	igDateEditor(optionLiteral: 'option', optionName: "type"): any;
	igDateEditor(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igDateEditor(optionLiteral: 'option', optionName: "locale"): any;
	igDateEditor(optionLiteral: 'option', optionName: "locale", optionValue: any): void;
	igDateEditor(optionLiteral: 'option', optionName: "width"): number;
	igDateEditor(optionLiteral: 'option', optionName: "width", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "height"): number;
	igDateEditor(optionLiteral: 'option', optionName: "height", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "validatorOptions"): any;
	igDateEditor(optionLiteral: 'option', optionName: "validatorOptions", optionValue: any): void;
	igDateEditor(optionLiteral: 'option', optionName: "required"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "required", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "display"): string;
	igDateEditor(optionLiteral: 'option', optionName: "display", optionValue: string): void;
	igDateEditor(optionLiteral: 'option', optionName: "renderInContainer"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "renderInContainer", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "selectionOnFocus"): any;
	igDateEditor(optionLiteral: 'option', optionName: "selectionOnFocus", optionValue: any): void;
	igDateEditor(optionLiteral: 'option', optionName: "readOnly"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "readOnly", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "spinOnReadOnly"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "spinOnReadOnly", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "focusOnSpin"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "focusOnSpin", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "spinWrapAround"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "spinWrapAround", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "hideEnterKey"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "hideEnterKey", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "dropDownOnReadOnly"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "dropDownOnReadOnly", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "dropDownTriggers"): any;
	igDateEditor(optionLiteral: 'option', optionName: "dropDownTriggers", optionValue: any): void;
	igDateEditor(optionLiteral: 'option', optionName: "listDropDownAsChild"): boolean;
	igDateEditor(optionLiteral: 'option', optionName: "listDropDownAsChild", optionValue: boolean): void;
	igDateEditor(optionLiteral: 'option', optionName: "listWidth"): number;
	igDateEditor(optionLiteral: 'option', optionName: "listWidth", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "listMaxHeight"): number;
	igDateEditor(optionLiteral: 'option', optionName: "listMaxHeight", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "listColumns"): number;
	igDateEditor(optionLiteral: 'option', optionName: "listColumns", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "animationShowDuration"): number;
	igDateEditor(optionLiteral: 'option', optionName: "animationShowDuration", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "animationHideDuration"): number;
	igDateEditor(optionLiteral: 'option', optionName: "animationHideDuration", optionValue: number): void;
	igDateEditor(optionLiteral: 'option', optionName: "inputName"): string;
	igDateEditor(optionLiteral: 'option', optionName: "inputName", optionValue: string): void;
	igDateEditor(optionLiteral: 'option', optionName: "keydown"): KeydownEvent;
	igDateEditor(optionLiteral: 'option', optionName: "keydown", optionValue: KeydownEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "keypress"): KeypressEvent;
	igDateEditor(optionLiteral: 'option', optionName: "keypress", optionValue: KeypressEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "keyup"): KeyupEvent;
	igDateEditor(optionLiteral: 'option', optionName: "keyup", optionValue: KeyupEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "mousedown"): MousedownEvent;
	igDateEditor(optionLiteral: 'option', optionName: "mousedown", optionValue: MousedownEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "mouseup"): MouseupEvent;
	igDateEditor(optionLiteral: 'option', optionName: "mouseup", optionValue: MouseupEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "mousemove"): MousemoveEvent;
	igDateEditor(optionLiteral: 'option', optionName: "mousemove", optionValue: MousemoveEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "mouseover"): MouseoverEvent;
	igDateEditor(optionLiteral: 'option', optionName: "mouseover", optionValue: MouseoverEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "mouseleave"): MouseleaveEvent;
	igDateEditor(optionLiteral: 'option', optionName: "mouseleave", optionValue: MouseleaveEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "focus"): FocusEvent;
	igDateEditor(optionLiteral: 'option', optionName: "focus", optionValue: FocusEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "blur"): BlurEvent;
	igDateEditor(optionLiteral: 'option', optionName: "blur", optionValue: BlurEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "valueChanging"): ValueChangingEvent;
	igDateEditor(optionLiteral: 'option', optionName: "valueChanging", optionValue: ValueChangingEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "valueChanged"): ValueChangedEvent;
	igDateEditor(optionLiteral: 'option', optionName: "valueChanged", optionValue: ValueChangedEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "textChanged"): TextChangedEvent;
	igDateEditor(optionLiteral: 'option', optionName: "textChanged", optionValue: TextChangedEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "invalidValue"): InvalidValueEvent;
	igDateEditor(optionLiteral: 'option', optionName: "invalidValue", optionValue: InvalidValueEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "spin"): SpinEvent;
	igDateEditor(optionLiteral: 'option', optionName: "spin", optionValue: SpinEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "buttonClick"): ButtonClickEvent;
	igDateEditor(optionLiteral: 'option', optionName: "buttonClick", optionValue: ButtonClickEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "showDropDown"): ShowDropDownEvent;
	igDateEditor(optionLiteral: 'option', optionName: "showDropDown", optionValue: ShowDropDownEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "hideDropDown"): HideDropDownEvent;
	igDateEditor(optionLiteral: 'option', optionName: "hideDropDown", optionValue: HideDropDownEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "listSelecting"): ListSelectingEvent;
	igDateEditor(optionLiteral: 'option', optionName: "listSelecting", optionValue: ListSelectingEvent): void;
	igDateEditor(optionLiteral: 'option', optionName: "listSelected"): ListSelectedEvent;
	igDateEditor(optionLiteral: 'option', optionName: "listSelected", optionValue: ListSelectedEvent): void;
	igDateEditor(options: IgDateEditor): JQuery;
	igDateEditor(optionLiteral: 'option', optionName: string): any;
	igDateEditor(optionLiteral: 'option', options: IgDateEditor): JQuery;
	igDateEditor(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igDateEditor(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igDatePicker(optionLiteral: 'option', optionName: "button"): any;
	igDatePicker(optionLiteral: 'option', optionName: "button", optionValue: any): void;
	igDatePicker(optionLiteral: 'option', optionName: "focusOnDropDownOpen"): boolean;
	igDatePicker(optionLiteral: 'option', optionName: "focusOnDropDownOpen", optionValue: boolean): void;
	igDatePicker(optionLiteral: 'option', optionName: "datepickerOptions"): any;
	igDatePicker(optionLiteral: 'option', optionName: "datepickerOptions", optionValue: any): void;
	igDatePicker(optionLiteral: 'option', optionName: "regional"): any;
	igDatePicker(optionLiteral: 'option', optionName: "regional", optionValue: any): void;
	igDatePicker(optionLiteral: 'option', optionName: "spin1Field"): boolean;
	igDatePicker(optionLiteral: 'option', optionName: "spin1Field", optionValue: boolean): void;
	igDatePicker(optionLiteral: 'option', optionName: "minValue"): Object;
	igDatePicker(optionLiteral: 'option', optionName: "minValue", optionValue: Object): void;
	igDatePicker(optionLiteral: 'option', optionName: "maxValue"): Object;
	igDatePicker(optionLiteral: 'option', optionName: "maxValue", optionValue: Object): void;
	igDatePicker(optionLiteral: 'option', optionName: "dateDisplayFormat"): string;
	igDatePicker(optionLiteral: 'option', optionName: "dateDisplayFormat", optionValue: string): void;
	igDatePicker(optionLiteral: 'option', optionName: "dateInputFormat"): string;
	igDatePicker(optionLiteral: 'option', optionName: "dateInputFormat", optionValue: string): void;
	igDatePicker(optionLiteral: 'option', optionName: "promptChar"): string;
	igDatePicker(optionLiteral: 'option', optionName: "promptChar", optionValue: string): void;
	igDatePicker(optionLiteral: 'option', optionName: "dataMode"): any;
	igDatePicker(optionLiteral: 'option', optionName: "dataMode", optionValue: any): void;
	igDatePicker(optionLiteral: 'option', optionName: "minNumberOfDateFields"): number;
	igDatePicker(optionLiteral: 'option', optionName: "minNumberOfDateFields", optionValue: number): void;
	igDatePicker(optionLiteral: 'option', optionName: "useLastGoodDate"): boolean;
	igDatePicker(optionLiteral: 'option', optionName: "useLastGoodDate", optionValue: boolean): void;
	igDatePicker(optionLiteral: 'option', optionName: "reduceDayOfInvalidDate"): boolean;
	igDatePicker(optionLiteral: 'option', optionName: "reduceDayOfInvalidDate", optionValue: boolean): void;
	igDatePicker(optionLiteral: 'option', optionName: "hideMaskOnFocus"): boolean;
	igDatePicker(optionLiteral: 'option', optionName: "hideMaskOnFocus", optionValue: boolean): void;
	igDatePicker(optionLiteral: 'option', optionName: "centuryThreshold"): number;
	igDatePicker(optionLiteral: 'option', optionName: "centuryThreshold", optionValue: number): void;
	igDatePicker(optionLiteral: 'option', optionName: "enableUTCDates"): boolean;
	igDatePicker(optionLiteral: 'option', optionName: "enableUTCDates", optionValue: boolean): void;
	igDatePicker(optionLiteral: 'option', optionName: "spinDelta"): number;
	igDatePicker(optionLiteral: 'option', optionName: "spinDelta", optionValue: number): void;
	igDatePicker(optionLiteral: 'option', optionName: "nullable"): boolean;
	igDatePicker(optionLiteral: 'option', optionName: "nullable", optionValue: boolean): void;
	igDatePicker(optionLiteral: 'option', optionName: "yearShift"): number;
	igDatePicker(optionLiteral: 'option', optionName: "yearShift", optionValue: number): void;
	igDatePicker(options: IgDatePicker): JQuery;
	igDatePicker(optionLiteral: 'option', optionName: string): any;
	igDatePicker(optionLiteral: 'option', options: IgDatePicker): JQuery;
	igDatePicker(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igDatePicker(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igNumericEditor(methodName: "validate", noLabel?: boolean): boolean;
	igNumericEditor(methodName: "isValid"): boolean;
	igNumericEditor(methodName: "getRegionalOption", name: string): string;
	igNumericEditor(methodName: "field"): void;
	igNumericEditor(methodName: "mainElement"): void;
	igNumericEditor(methodName: "dropDownElement"): void;
	igNumericEditor(methodName: "show"): Object;
	igNumericEditor(methodName: "hide"): Object;
	igNumericEditor(methodName: "remove"): Object;
	igNumericEditor(methodName: "dropDownVisible", showHide?: boolean): void;
	igNumericEditor(methodName: "findListItemIndex", text: string, ignoreCase?: boolean, partial?: boolean, contains?: boolean): number;
	igNumericEditor(methodName: "addListItems", items: Object, index?: number): Object;
	igNumericEditor(methodName: "addListItem", item: Object, index?: number): Object;
	igNumericEditor(methodName: "removeListItem", item: Object): Object;
	igNumericEditor(methodName: "removeListItemAt", index: number): Object;
	igNumericEditor(methodName: "clearListItems"): Object;
	igNumericEditor(methodName: "selectedListIndex", index?: number): number;
	igNumericEditor(methodName: "getSelectedListItem"): void;
	igNumericEditor(methodName: "hasInvalidMessage"): boolean;
	igNumericEditor(methodName: "validator"): Object;
	igNumericEditor(methodName: "text", val?: string, flag?: number): void;
	igNumericEditor(methodName: "value", val?: Object): void;
	igNumericEditor(methodName: "paste", txt: string, flag?: boolean): Object;
	igNumericEditor(methodName: "select", sel0?: number, sel1?: number, val?: string): Object;
	igNumericEditor(methodName: "getSelectedText"): string;
	igNumericEditor(methodName: "getSelection", start?: boolean): number;
	igNumericEditor(methodName: "setFocus", delay?: number): Object;
	igNumericEditor(methodName: "hasFocus"): boolean;
	igNumericEditor(methodName: "getValueByMode", mode: string, v?: Object, getVal?: Object): void;
	igNumericEditor(methodName: "spin", delta: number): Object;
	igNumericEditor(methodName: "destroy"): Object;
	igNumericEditor(optionLiteral: 'option', optionName: "regional"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "regional", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "negativePattern"): string;
	igNumericEditor(optionLiteral: 'option', optionName: "negativePattern", optionValue: string): void;
	igNumericEditor(optionLiteral: 'option', optionName: "negativeSign"): string;
	igNumericEditor(optionLiteral: 'option', optionName: "negativeSign", optionValue: string): void;
	igNumericEditor(optionLiteral: 'option', optionName: "decimalSeparator"): string;
	igNumericEditor(optionLiteral: 'option', optionName: "decimalSeparator", optionValue: string): void;
	igNumericEditor(optionLiteral: 'option', optionName: "groupSeparator"): string;
	igNumericEditor(optionLiteral: 'option', optionName: "groupSeparator", optionValue: string): void;
	igNumericEditor(optionLiteral: 'option', optionName: "groups"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "groups", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "maxDecimals"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "maxDecimals", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "minDecimals"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "minDecimals", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "minValue"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "minValue", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "maxValue"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "maxValue", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "scientificFormat"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "scientificFormat", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "nullValue"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "nullValue", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "spinDelta"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "spinDelta", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "nullable"): boolean;
	igNumericEditor(optionLiteral: 'option', optionName: "nullable", optionValue: boolean): void;
	igNumericEditor(optionLiteral: 'option', optionName: "maxLength"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "maxLength", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "dataMode"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "dataMode", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "value"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "value", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "tabIndex"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "tabIndex", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "nullText"): string;
	igNumericEditor(optionLiteral: 'option', optionName: "nullText", optionValue: string): void;
	igNumericEditor(optionLiteral: 'option', optionName: "button"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "button", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "textAlign"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "textAlign", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "listItems"): any[];
	igNumericEditor(optionLiteral: 'option', optionName: "listItems", optionValue: any[]): void;
	igNumericEditor(optionLiteral: 'option', optionName: "theme"): string;
	igNumericEditor(optionLiteral: 'option', optionName: "theme", optionValue: string): void;
	igNumericEditor(optionLiteral: 'option', optionName: "type"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "locale"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "locale", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "width"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "width", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "height"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "height", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "validatorOptions"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "validatorOptions", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "required"): boolean;
	igNumericEditor(optionLiteral: 'option', optionName: "required", optionValue: boolean): void;
	igNumericEditor(optionLiteral: 'option', optionName: "display"): string;
	igNumericEditor(optionLiteral: 'option', optionName: "display", optionValue: string): void;
	igNumericEditor(optionLiteral: 'option', optionName: "renderInContainer"): boolean;
	igNumericEditor(optionLiteral: 'option', optionName: "renderInContainer", optionValue: boolean): void;
	igNumericEditor(optionLiteral: 'option', optionName: "selectionOnFocus"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "selectionOnFocus", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "readOnly"): boolean;
	igNumericEditor(optionLiteral: 'option', optionName: "readOnly", optionValue: boolean): void;
	igNumericEditor(optionLiteral: 'option', optionName: "spinOnReadOnly"): boolean;
	igNumericEditor(optionLiteral: 'option', optionName: "spinOnReadOnly", optionValue: boolean): void;
	igNumericEditor(optionLiteral: 'option', optionName: "focusOnSpin"): boolean;
	igNumericEditor(optionLiteral: 'option', optionName: "focusOnSpin", optionValue: boolean): void;
	igNumericEditor(optionLiteral: 'option', optionName: "spinWrapAround"): boolean;
	igNumericEditor(optionLiteral: 'option', optionName: "spinWrapAround", optionValue: boolean): void;
	igNumericEditor(optionLiteral: 'option', optionName: "hideEnterKey"): boolean;
	igNumericEditor(optionLiteral: 'option', optionName: "hideEnterKey", optionValue: boolean): void;
	igNumericEditor(optionLiteral: 'option', optionName: "dropDownOnReadOnly"): boolean;
	igNumericEditor(optionLiteral: 'option', optionName: "dropDownOnReadOnly", optionValue: boolean): void;
	igNumericEditor(optionLiteral: 'option', optionName: "dropDownTriggers"): any;
	igNumericEditor(optionLiteral: 'option', optionName: "dropDownTriggers", optionValue: any): void;
	igNumericEditor(optionLiteral: 'option', optionName: "listDropDownAsChild"): boolean;
	igNumericEditor(optionLiteral: 'option', optionName: "listDropDownAsChild", optionValue: boolean): void;
	igNumericEditor(optionLiteral: 'option', optionName: "listWidth"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "listWidth", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "listMaxHeight"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "listMaxHeight", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "listColumns"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "listColumns", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "animationShowDuration"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "animationShowDuration", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "animationHideDuration"): number;
	igNumericEditor(optionLiteral: 'option', optionName: "animationHideDuration", optionValue: number): void;
	igNumericEditor(optionLiteral: 'option', optionName: "inputName"): string;
	igNumericEditor(optionLiteral: 'option', optionName: "inputName", optionValue: string): void;
	igNumericEditor(optionLiteral: 'option', optionName: "keydown"): KeydownEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "keydown", optionValue: KeydownEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "keypress"): KeypressEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "keypress", optionValue: KeypressEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "keyup"): KeyupEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "keyup", optionValue: KeyupEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "mousedown"): MousedownEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "mousedown", optionValue: MousedownEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "mouseup"): MouseupEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "mouseup", optionValue: MouseupEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "mousemove"): MousemoveEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "mousemove", optionValue: MousemoveEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "mouseover"): MouseoverEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "mouseover", optionValue: MouseoverEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "mouseleave"): MouseleaveEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "mouseleave", optionValue: MouseleaveEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "focus"): FocusEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "focus", optionValue: FocusEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "blur"): BlurEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "blur", optionValue: BlurEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "valueChanging"): ValueChangingEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "valueChanging", optionValue: ValueChangingEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "valueChanged"): ValueChangedEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "valueChanged", optionValue: ValueChangedEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "textChanged"): TextChangedEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "textChanged", optionValue: TextChangedEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "invalidValue"): InvalidValueEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "invalidValue", optionValue: InvalidValueEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "spin"): SpinEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "spin", optionValue: SpinEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "buttonClick"): ButtonClickEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "buttonClick", optionValue: ButtonClickEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "showDropDown"): ShowDropDownEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "showDropDown", optionValue: ShowDropDownEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "hideDropDown"): HideDropDownEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "hideDropDown", optionValue: HideDropDownEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "listSelecting"): ListSelectingEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "listSelecting", optionValue: ListSelectingEvent): void;
	igNumericEditor(optionLiteral: 'option', optionName: "listSelected"): ListSelectedEvent;
	igNumericEditor(optionLiteral: 'option', optionName: "listSelected", optionValue: ListSelectedEvent): void;
	igNumericEditor(options: IgNumericEditor): JQuery;
	igNumericEditor(optionLiteral: 'option', optionName: string): any;
	igNumericEditor(optionLiteral: 'option', options: IgNumericEditor): JQuery;
	igNumericEditor(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igNumericEditor(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igCurrencyEditor(optionLiteral: 'option', optionName: "positivePattern"): string;
	igCurrencyEditor(optionLiteral: 'option', optionName: "positivePattern", optionValue: string): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "negativePattern"): string;
	igCurrencyEditor(optionLiteral: 'option', optionName: "negativePattern", optionValue: string): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "symbol"): string;
	igCurrencyEditor(optionLiteral: 'option', optionName: "symbol", optionValue: string): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "regional"): any;
	igCurrencyEditor(optionLiteral: 'option', optionName: "regional", optionValue: any): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "negativePattern"): string;
	igCurrencyEditor(optionLiteral: 'option', optionName: "negativePattern", optionValue: string): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "negativeSign"): string;
	igCurrencyEditor(optionLiteral: 'option', optionName: "negativeSign", optionValue: string): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "decimalSeparator"): string;
	igCurrencyEditor(optionLiteral: 'option', optionName: "decimalSeparator", optionValue: string): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "groupSeparator"): string;
	igCurrencyEditor(optionLiteral: 'option', optionName: "groupSeparator", optionValue: string): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "groups"): any;
	igCurrencyEditor(optionLiteral: 'option', optionName: "groups", optionValue: any): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "maxDecimals"): number;
	igCurrencyEditor(optionLiteral: 'option', optionName: "maxDecimals", optionValue: number): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "minDecimals"): number;
	igCurrencyEditor(optionLiteral: 'option', optionName: "minDecimals", optionValue: number): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "minValue"): number;
	igCurrencyEditor(optionLiteral: 'option', optionName: "minValue", optionValue: number): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "maxValue"): number;
	igCurrencyEditor(optionLiteral: 'option', optionName: "maxValue", optionValue: number): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "scientificFormat"): any;
	igCurrencyEditor(optionLiteral: 'option', optionName: "scientificFormat", optionValue: any): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "nullValue"): number;
	igCurrencyEditor(optionLiteral: 'option', optionName: "nullValue", optionValue: number): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "spinDelta"): number;
	igCurrencyEditor(optionLiteral: 'option', optionName: "spinDelta", optionValue: number): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "nullable"): boolean;
	igCurrencyEditor(optionLiteral: 'option', optionName: "nullable", optionValue: boolean): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "maxLength"): number;
	igCurrencyEditor(optionLiteral: 'option', optionName: "maxLength", optionValue: number): void;
	igCurrencyEditor(optionLiteral: 'option', optionName: "dataMode"): any;
	igCurrencyEditor(optionLiteral: 'option', optionName: "dataMode", optionValue: any): void;
	igCurrencyEditor(options: IgCurrencyEditor): JQuery;
	igCurrencyEditor(optionLiteral: 'option', optionName: string): any;
	igCurrencyEditor(optionLiteral: 'option', options: IgCurrencyEditor): JQuery;
	igCurrencyEditor(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igCurrencyEditor(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igPercentEditor(optionLiteral: 'option', optionName: "positivePattern"): string;
	igPercentEditor(optionLiteral: 'option', optionName: "positivePattern", optionValue: string): void;
	igPercentEditor(optionLiteral: 'option', optionName: "negativePattern"): string;
	igPercentEditor(optionLiteral: 'option', optionName: "negativePattern", optionValue: string): void;
	igPercentEditor(optionLiteral: 'option', optionName: "symbol"): string;
	igPercentEditor(optionLiteral: 'option', optionName: "symbol", optionValue: string): void;
	igPercentEditor(optionLiteral: 'option', optionName: "displayFactor"): number;
	igPercentEditor(optionLiteral: 'option', optionName: "displayFactor", optionValue: number): void;
	igPercentEditor(optionLiteral: 'option', optionName: "regional"): any;
	igPercentEditor(optionLiteral: 'option', optionName: "regional", optionValue: any): void;
	igPercentEditor(optionLiteral: 'option', optionName: "negativePattern"): string;
	igPercentEditor(optionLiteral: 'option', optionName: "negativePattern", optionValue: string): void;
	igPercentEditor(optionLiteral: 'option', optionName: "negativeSign"): string;
	igPercentEditor(optionLiteral: 'option', optionName: "negativeSign", optionValue: string): void;
	igPercentEditor(optionLiteral: 'option', optionName: "decimalSeparator"): string;
	igPercentEditor(optionLiteral: 'option', optionName: "decimalSeparator", optionValue: string): void;
	igPercentEditor(optionLiteral: 'option', optionName: "groupSeparator"): string;
	igPercentEditor(optionLiteral: 'option', optionName: "groupSeparator", optionValue: string): void;
	igPercentEditor(optionLiteral: 'option', optionName: "groups"): any;
	igPercentEditor(optionLiteral: 'option', optionName: "groups", optionValue: any): void;
	igPercentEditor(optionLiteral: 'option', optionName: "maxDecimals"): number;
	igPercentEditor(optionLiteral: 'option', optionName: "maxDecimals", optionValue: number): void;
	igPercentEditor(optionLiteral: 'option', optionName: "minDecimals"): number;
	igPercentEditor(optionLiteral: 'option', optionName: "minDecimals", optionValue: number): void;
	igPercentEditor(optionLiteral: 'option', optionName: "minValue"): number;
	igPercentEditor(optionLiteral: 'option', optionName: "minValue", optionValue: number): void;
	igPercentEditor(optionLiteral: 'option', optionName: "maxValue"): number;
	igPercentEditor(optionLiteral: 'option', optionName: "maxValue", optionValue: number): void;
	igPercentEditor(optionLiteral: 'option', optionName: "scientificFormat"): any;
	igPercentEditor(optionLiteral: 'option', optionName: "scientificFormat", optionValue: any): void;
	igPercentEditor(optionLiteral: 'option', optionName: "nullValue"): number;
	igPercentEditor(optionLiteral: 'option', optionName: "nullValue", optionValue: number): void;
	igPercentEditor(optionLiteral: 'option', optionName: "spinDelta"): number;
	igPercentEditor(optionLiteral: 'option', optionName: "spinDelta", optionValue: number): void;
	igPercentEditor(optionLiteral: 'option', optionName: "nullable"): boolean;
	igPercentEditor(optionLiteral: 'option', optionName: "nullable", optionValue: boolean): void;
	igPercentEditor(optionLiteral: 'option', optionName: "maxLength"): number;
	igPercentEditor(optionLiteral: 'option', optionName: "maxLength", optionValue: number): void;
	igPercentEditor(optionLiteral: 'option', optionName: "dataMode"): any;
	igPercentEditor(optionLiteral: 'option', optionName: "dataMode", optionValue: any): void;
	igPercentEditor(options: IgPercentEditor): JQuery;
	igPercentEditor(optionLiteral: 'option', optionName: string): any;
	igPercentEditor(optionLiteral: 'option', options: IgPercentEditor): JQuery;
	igPercentEditor(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igPercentEditor(methodName: string, ...methodParams: any[]): any;
}
interface SliceClickedEvent {
	(event: Event, ui: SliceClickedEventUIParam): void;
}

interface SliceClickedEventUIParam {
	owner?: any;
	index?: any;
	item?: any;
	selected?: any;
}

interface IgFunnelChart {
	bezierPoints?: string;
	legend?: any;
	valueMemberPath?: string;
	brushes?: any;
	outlines?: any;
	bottomEdgeWidth?: number;
	innerLabelMemberPath?: string;
	outerLabelMemberPath?: string;
	innerLabelVisibility?: any;
	outerLabelVisibility?: any;
	outerLabelAlignment?: any;
	funnelSliceDisplay?: any;
	formatInnerLabel?: any;
	formatOuterLabel?: any;
	transitionDuration?: number;
	isInverted?: boolean;
	useBezierCurve?: boolean;
	allowSliceSelection?: boolean;
	useUnselectedStyle?: boolean;
	selectedSliceStyle?: any;
	unselectedSliceStyle?: any;
	legendItemBadgeTemplate?: any;
	useOuterLabelsForLegend?: boolean;
	outlineThickness?: number;
	sliceClicked?: SliceClickedEvent;
}
interface IgFunnelChartMethods {
	selectedSliceItems(selection?: any[]): void;
	selectedSliceIndexes(selection?: any[]): void;
	isSelected(slice: Object): boolean;
	toggleSelection(slice: Object): Object;
	exportVisualData(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igFunnelChart"):IgFunnelChartMethods;
}

interface JQuery {
	igFunnelChart(methodName: "selectedSliceItems", selection?: any[]): void;
	igFunnelChart(methodName: "selectedSliceIndexes", selection?: any[]): void;
	igFunnelChart(methodName: "isSelected", slice: Object): boolean;
	igFunnelChart(methodName: "toggleSelection", slice: Object): Object;
	igFunnelChart(methodName: "exportVisualData"): void;
	igFunnelChart(methodName: "destroy"): void;
	igFunnelChart(optionLiteral: 'option', optionName: "bezierPoints"): string;
	igFunnelChart(optionLiteral: 'option', optionName: "bezierPoints", optionValue: string): void;
	igFunnelChart(optionLiteral: 'option', optionName: "legend"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "legend", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "valueMemberPath"): string;
	igFunnelChart(optionLiteral: 'option', optionName: "valueMemberPath", optionValue: string): void;
	igFunnelChart(optionLiteral: 'option', optionName: "brushes"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "brushes", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "outlines"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "outlines", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "bottomEdgeWidth"): number;
	igFunnelChart(optionLiteral: 'option', optionName: "bottomEdgeWidth", optionValue: number): void;
	igFunnelChart(optionLiteral: 'option', optionName: "innerLabelMemberPath"): string;
	igFunnelChart(optionLiteral: 'option', optionName: "innerLabelMemberPath", optionValue: string): void;
	igFunnelChart(optionLiteral: 'option', optionName: "outerLabelMemberPath"): string;
	igFunnelChart(optionLiteral: 'option', optionName: "outerLabelMemberPath", optionValue: string): void;
	igFunnelChart(optionLiteral: 'option', optionName: "innerLabelVisibility"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "innerLabelVisibility", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "outerLabelVisibility"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "outerLabelVisibility", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "outerLabelAlignment"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "outerLabelAlignment", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "funnelSliceDisplay"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "funnelSliceDisplay", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "formatInnerLabel"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "formatInnerLabel", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "formatOuterLabel"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "formatOuterLabel", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "transitionDuration"): number;
	igFunnelChart(optionLiteral: 'option', optionName: "transitionDuration", optionValue: number): void;
	igFunnelChart(optionLiteral: 'option', optionName: "isInverted"): boolean;
	igFunnelChart(optionLiteral: 'option', optionName: "isInverted", optionValue: boolean): void;
	igFunnelChart(optionLiteral: 'option', optionName: "useBezierCurve"): boolean;
	igFunnelChart(optionLiteral: 'option', optionName: "useBezierCurve", optionValue: boolean): void;
	igFunnelChart(optionLiteral: 'option', optionName: "allowSliceSelection"): boolean;
	igFunnelChart(optionLiteral: 'option', optionName: "allowSliceSelection", optionValue: boolean): void;
	igFunnelChart(optionLiteral: 'option', optionName: "useUnselectedStyle"): boolean;
	igFunnelChart(optionLiteral: 'option', optionName: "useUnselectedStyle", optionValue: boolean): void;
	igFunnelChart(optionLiteral: 'option', optionName: "selectedSliceStyle"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "selectedSliceStyle", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "unselectedSliceStyle"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "unselectedSliceStyle", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "legendItemBadgeTemplate"): any;
	igFunnelChart(optionLiteral: 'option', optionName: "legendItemBadgeTemplate", optionValue: any): void;
	igFunnelChart(optionLiteral: 'option', optionName: "useOuterLabelsForLegend"): boolean;
	igFunnelChart(optionLiteral: 'option', optionName: "useOuterLabelsForLegend", optionValue: boolean): void;
	igFunnelChart(optionLiteral: 'option', optionName: "outlineThickness"): number;
	igFunnelChart(optionLiteral: 'option', optionName: "outlineThickness", optionValue: number): void;
	igFunnelChart(optionLiteral: 'option', optionName: "sliceClicked"): SliceClickedEvent;
	igFunnelChart(optionLiteral: 'option', optionName: "sliceClicked", optionValue: SliceClickedEvent): void;
	igFunnelChart(options: IgFunnelChart): JQuery;
	igFunnelChart(optionLiteral: 'option', optionName: string): any;
	igFunnelChart(optionLiteral: 'option', options: IgFunnelChart): JQuery;
	igFunnelChart(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igFunnelChart(methodName: string, ...methodParams: any[]): any;
}
interface CellsMergingEvent {
	(event: Event, ui: CellsMergingEventUIParam): void;
}

interface CellsMergingEventUIParam {
	row?: any;
	rowIndex?: any;
	rowKey?: any;
	owner?: any;
	grid?: any;
	value?: any;
}

interface CellsMergedEvent {
	(event: Event, ui: CellsMergedEventUIParam): void;
}

interface CellsMergedEventUIParam {
	row?: any;
	rowIndex?: any;
	rowKey?: any;
	owner?: any;
	grid?: any;
	value?: any;
	count?: any;
}

interface IgGridCellMerging {
	initialState?: any;
	inherit?: boolean;
	cellsMerging?: CellsMergingEvent;
	cellsMerged?: CellsMergedEvent;
}
interface IgGridCellMergingMethods {
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igGridCellMerging"):IgGridCellMergingMethods;
}

interface JQuery {
	igGridCellMerging(methodName: "destroy"): void;
	igGridCellMerging(optionLiteral: 'option', optionName: "initialState"): any;
	igGridCellMerging(optionLiteral: 'option', optionName: "initialState", optionValue: any): void;
	igGridCellMerging(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridCellMerging(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridCellMerging(optionLiteral: 'option', optionName: "cellsMerging"): CellsMergingEvent;
	igGridCellMerging(optionLiteral: 'option', optionName: "cellsMerging", optionValue: CellsMergingEvent): void;
	igGridCellMerging(optionLiteral: 'option', optionName: "cellsMerged"): CellsMergedEvent;
	igGridCellMerging(optionLiteral: 'option', optionName: "cellsMerged", optionValue: CellsMergedEvent): void;
	igGridCellMerging(options: IgGridCellMerging): JQuery;
	igGridCellMerging(optionLiteral: 'option', optionName: string): any;
	igGridCellMerging(optionLiteral: 'option', options: IgGridCellMerging): JQuery;
	igGridCellMerging(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridCellMerging(methodName: string, ...methodParams: any[]): any;
}
interface IgGridColumnFixingColumnSetting {
	columnKey?: string;
	columnIndex?: number;
	allowFixing?: boolean;
	isFixed?: boolean;
}

interface ColumnFixingEvent {
	(event: Event, ui: ColumnFixingEventUIParam): void;
}

interface ColumnFixingEventUIParam {
	columnIdentifier?: any;
	isGroupHeader?: any;
	owner?: any;
}

interface ColumnFixedEvent {
	(event: Event, ui: ColumnFixedEventUIParam): void;
}

interface ColumnFixedEventUIParam {
	columnIdentifier?: any;
	isGroupHeader?: any;
	owner?: any;
}

interface ColumnUnfixingEvent {
	(event: Event, ui: ColumnUnfixingEventUIParam): void;
}

interface ColumnUnfixingEventUIParam {
	columnIdentifier?: any;
	isGroupHeader?: any;
	owner?: any;
}

interface ColumnUnfixedEvent {
	(event: Event, ui: ColumnUnfixedEventUIParam): void;
}

interface ColumnUnfixedEventUIParam {
	columnIdentifier?: any;
	isGroupHeader?: any;
	owner?: any;
}

interface ColumnFixingRefusedEvent {
	(event: Event, ui: ColumnFixingRefusedEventUIParam): void;
}

interface ColumnFixingRefusedEventUIParam {
	columnIdentifier?: any;
	isGroupHeader?: any;
	errorMessage?: any;
	owner?: any;
}

interface ColumnUnfixingRefusedEvent {
	(event: Event, ui: ColumnUnfixingRefusedEventUIParam): void;
}

interface ColumnUnfixingRefusedEventUIParam {
	columnIdentifier?: any;
	isGroupHeader?: any;
	errorMessage?: any;
	owner?: any;
}

interface IgGridColumnFixing {
	headerFixButtonText?: string;
	headerUnfixButtonText?: string;
	showFixButtons?: boolean;
	syncRowHeights?: boolean;
	scrollDelta?: number;
	fixingDirection?: any;
	columnSettings?: IgGridColumnFixingColumnSetting[];
	featureChooserTextFixedColumn?: string;
	featureChooserTextUnfixedColumn?: string;
	minimalVisibleAreaWidth?: any;
	fixNondataColumns?: boolean;
	populateDataRowsAttributes?: boolean;
	columnFixing?: ColumnFixingEvent;
	columnFixed?: ColumnFixedEvent;
	columnUnfixing?: ColumnUnfixingEvent;
	columnUnfixed?: ColumnUnfixedEvent;
	columnFixingRefused?: ColumnFixingRefusedEvent;
	columnUnfixingRefused?: ColumnUnfixingRefusedEvent;
}
interface IgGridColumnFixingMethods {
	unfixColumn(colIdentifier: Object, isGroupHeader?: boolean, target?: string, after?: boolean): Object;
	checkAndSyncHeights(): void;
	unfixDataSkippedColumns(): void;
	unfixAllColumns(): void;
	checkFixingAllowed(columns: any[]): boolean;
	checkUnfixingAllowed(columns: any[]): boolean;
	fixColumn(colIdentifier: Object, isGroupHeader?: boolean, target?: string, after?: boolean): Object;
	fixDataSkippedColumns(): void;
	syncRowsHeights($trs: any[], $anotherRows: any[]): void;
	getWidthOfFixedColumns(fCols?: any[], excludeNonDataColumns?: boolean, includeHidden?: boolean): number;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igGridColumnFixing"):IgGridColumnFixingMethods;
}

interface JQuery {
	igGridColumnFixing(methodName: "unfixColumn", colIdentifier: Object, isGroupHeader?: boolean, target?: string, after?: boolean): Object;
	igGridColumnFixing(methodName: "checkAndSyncHeights"): void;
	igGridColumnFixing(methodName: "unfixDataSkippedColumns"): void;
	igGridColumnFixing(methodName: "unfixAllColumns"): void;
	igGridColumnFixing(methodName: "checkFixingAllowed", columns: any[]): boolean;
	igGridColumnFixing(methodName: "checkUnfixingAllowed", columns: any[]): boolean;
	igGridColumnFixing(methodName: "fixColumn", colIdentifier: Object, isGroupHeader?: boolean, target?: string, after?: boolean): Object;
	igGridColumnFixing(methodName: "fixDataSkippedColumns"): void;
	igGridColumnFixing(methodName: "syncRowsHeights", $trs: any[], $anotherRows: any[]): void;
	igGridColumnFixing(methodName: "getWidthOfFixedColumns", fCols?: any[], excludeNonDataColumns?: boolean, includeHidden?: boolean): number;
	igGridColumnFixing(methodName: "destroy"): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "headerFixButtonText"): string;
	igGridColumnFixing(optionLiteral: 'option', optionName: "headerFixButtonText", optionValue: string): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "headerUnfixButtonText"): string;
	igGridColumnFixing(optionLiteral: 'option', optionName: "headerUnfixButtonText", optionValue: string): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "showFixButtons"): boolean;
	igGridColumnFixing(optionLiteral: 'option', optionName: "showFixButtons", optionValue: boolean): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "syncRowHeights"): boolean;
	igGridColumnFixing(optionLiteral: 'option', optionName: "syncRowHeights", optionValue: boolean): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "scrollDelta"): number;
	igGridColumnFixing(optionLiteral: 'option', optionName: "scrollDelta", optionValue: number): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "fixingDirection"): any;
	igGridColumnFixing(optionLiteral: 'option', optionName: "fixingDirection", optionValue: any): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnSettings"): IgGridColumnFixingColumnSetting[];
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridColumnFixingColumnSetting[]): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "featureChooserTextFixedColumn"): string;
	igGridColumnFixing(optionLiteral: 'option', optionName: "featureChooserTextFixedColumn", optionValue: string): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "featureChooserTextUnfixedColumn"): string;
	igGridColumnFixing(optionLiteral: 'option', optionName: "featureChooserTextUnfixedColumn", optionValue: string): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "minimalVisibleAreaWidth"): any;
	igGridColumnFixing(optionLiteral: 'option', optionName: "minimalVisibleAreaWidth", optionValue: any): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "fixNondataColumns"): boolean;
	igGridColumnFixing(optionLiteral: 'option', optionName: "fixNondataColumns", optionValue: boolean): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "populateDataRowsAttributes"): boolean;
	igGridColumnFixing(optionLiteral: 'option', optionName: "populateDataRowsAttributes", optionValue: boolean): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnFixing"): ColumnFixingEvent;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnFixing", optionValue: ColumnFixingEvent): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnFixed"): ColumnFixedEvent;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnFixed", optionValue: ColumnFixedEvent): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixing"): ColumnUnfixingEvent;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixing", optionValue: ColumnUnfixingEvent): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixed"): ColumnUnfixedEvent;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixed", optionValue: ColumnUnfixedEvent): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnFixingRefused"): ColumnFixingRefusedEvent;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnFixingRefused", optionValue: ColumnFixingRefusedEvent): void;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixingRefused"): ColumnUnfixingRefusedEvent;
	igGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixingRefused", optionValue: ColumnUnfixingRefusedEvent): void;
	igGridColumnFixing(options: IgGridColumnFixing): JQuery;
	igGridColumnFixing(optionLiteral: 'option', optionName: string): any;
	igGridColumnFixing(optionLiteral: 'option', options: IgGridColumnFixing): JQuery;
	igGridColumnFixing(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridColumnFixing(methodName: string, ...methodParams: any[]): any;
}
interface IgGridColumnMovingColumnSetting {
	columnKey?: string;
	columnIndex?: number;
	allowMoving?: boolean;
}

interface ColumnDragStartEvent {
	(event: Event, ui: ColumnDragStartEventUIParam): void;
}

interface ColumnDragStartEventUIParam {
	columnKey?: any;
	columnIndex?: any;
	owner?: any;
	header?: any;
	helper?: any;
}

interface ColumnDragEndEvent {
	(event: Event, ui: ColumnDragEndEventUIParam): void;
}

interface ColumnDragEndEventUIParam {
	columnKey?: any;
	columnIndex?: any;
	owner?: any;
	header?: any;
	helper?: any;
}

interface ColumnDragCanceledEvent {
	(event: Event, ui: ColumnDragCanceledEventUIParam): void;
}

interface ColumnDragCanceledEventUIParam {
	columnKey?: any;
	columnIndex?: any;
	owner?: any;
	header?: any;
	helper?: any;
}

interface ColumnMovingEvent {
	(event: Event, ui: ColumnMovingEventUIParam): void;
}

interface ColumnMovingEventUIParam {
	columnKey?: any;
	columnIndex?: any;
	targetIndex?: any;
	owner?: any;
}

interface ColumnMovedEvent {
	(event: Event, ui: ColumnMovedEventUIParam): void;
}

interface ColumnMovedEventUIParam {
	columnKey?: any;
	oldIndex?: any;
	newIndex?: any;
	owner?: any;
}

interface MovingDialogOpeningEvent {
	(event: Event, ui: MovingDialogOpeningEventUIParam): void;
}

interface MovingDialogOpeningEventUIParam {
	owner?: any;
	movingDialogElement?: any;
}

interface MovingDialogOpenedEvent {
	(event: Event, ui: MovingDialogOpenedEventUIParam): void;
}

interface MovingDialogOpenedEventUIParam {
	owner?: any;
	movingDialogElement?: any;
}

interface MovingDialogDraggedEvent {
	(event: Event, ui: MovingDialogDraggedEventUIParam): void;
}

interface MovingDialogDraggedEventUIParam {
	owner?: any;
	movingDialogElement?: any;
	originalPosition?: any;
	position?: any;
}

interface MovingDialogClosingEvent {
	(event: Event, ui: MovingDialogClosingEventUIParam): void;
}

interface MovingDialogClosingEventUIParam {
	owner?: any;
	movingDialogElement?: any;
}

interface MovingDialogClosedEvent {
	(event: Event, ui: MovingDialogClosedEventUIParam): void;
}

interface MovingDialogClosedEventUIParam {
	owner?: any;
	movingDialogElement?: any;
}

interface MovingDialogContentsRenderingEvent {
	(event: Event, ui: MovingDialogContentsRenderingEventUIParam): void;
}

interface MovingDialogContentsRenderingEventUIParam {
	owner?: any;
	movingDialog?: any;
}

interface MovingDialogContentsRenderedEvent {
	(event: Event, ui: MovingDialogContentsRenderedEventUIParam): void;
}

interface MovingDialogContentsRenderedEventUIParam {
	owner?: any;
	movingDialog?: any;
}

interface MovingDialogMoveUpButtonPressedEvent {
	(event: Event, ui: MovingDialogMoveUpButtonPressedEventUIParam): void;
}

interface MovingDialogMoveUpButtonPressedEventUIParam {
	owner?: any;
	movingDialog?: any;
	columnKey?: any;
	columnIndex?: any;
	targetIndex?: any;
}

interface MovingDialogMoveDownButtonPressedEvent {
	(event: Event, ui: MovingDialogMoveDownButtonPressedEventUIParam): void;
}

interface MovingDialogMoveDownButtonPressedEventUIParam {
	owner?: any;
	movingDialog?: any;
	columnKey?: any;
	columnIndex?: any;
	targetIndex?: any;
}

interface MovingDialogDragColumnMovingEvent {
	(event: Event, ui: MovingDialogDragColumnMovingEventUIParam): void;
}

interface MovingDialogDragColumnMovingEventUIParam {
	owner?: any;
	movingDialog?: any;
	columnKey?: any;
	columnIndex?: any;
	targetIndex?: any;
}

interface MovingDialogDragColumnMovedEvent {
	(event: Event, ui: MovingDialogDragColumnMovedEventUIParam): void;
}

interface MovingDialogDragColumnMovedEventUIParam {
	owner?: any;
	movingDialog?: any;
	columnKey?: any;
	columnIndex?: any;
	targetIndex?: any;
}

interface IgGridColumnMoving {
	columnSettings?: IgGridColumnMovingColumnSetting[];
	mode?: any;
	moveType?: any;
	addMovingDropdown?: boolean;
	movingDialogWidth?: number;
	movingDialogHeight?: number;
	movingDialogAnimationDuration?: number;
	movingAcceptanceTolerance?: number;
	movingScrollTolerance?: number;
	scrollSpeedMultiplier?: number;
	scrollDelta?: number;
	hideHeaderContentsDuringDrag?: boolean;
	dragHelperOpacity?: number;
	movingDialogCaptionButtonDesc?: string;
	movingDialogCaptionButtonAsc?: string;
	movingDialogCaptionText?: string;
	movingDialogDisplayText?: string;
	movingDialogDropTooltipText?: string;
	movingDialogDropTooltipMarkup?: string;
	dropDownMoveLeftText?: string;
	dropDownMoveRightText?: string;
	dropDownMoveFirstText?: string;
	dropDownMoveLastText?: string;
	movingToolTipMove?: string;
	featureChooserSubmenuText?: string;
	columnMovingDialogContainment?: string;
	inherit?: boolean;
	columnDragStart?: ColumnDragStartEvent;
	columnDragEnd?: ColumnDragEndEvent;
	columnDragCanceled?: ColumnDragCanceledEvent;
	columnMoving?: ColumnMovingEvent;
	columnMoved?: ColumnMovedEvent;
	movingDialogOpening?: MovingDialogOpeningEvent;
	movingDialogOpened?: MovingDialogOpenedEvent;
	movingDialogDragged?: MovingDialogDraggedEvent;
	movingDialogClosing?: MovingDialogClosingEvent;
	movingDialogClosed?: MovingDialogClosedEvent;
	movingDialogContentsRendering?: MovingDialogContentsRenderingEvent;
	movingDialogContentsRendered?: MovingDialogContentsRenderedEvent;
	movingDialogMoveUpButtonPressed?: MovingDialogMoveUpButtonPressedEvent;
	movingDialogMoveDownButtonPressed?: MovingDialogMoveDownButtonPressedEvent;
	movingDialogDragColumnMoving?: MovingDialogDragColumnMovingEvent;
	movingDialogDragColumnMoved?: MovingDialogDragColumnMovedEvent;
}
interface IgGridColumnMovingMethods {
	destroy(): void;
	moveColumn(column: Object, target: Object, after?: boolean, inDom?: boolean, callback?: Function): void;
}
interface JQuery {
	data(propertyName: "igGridColumnMoving"):IgGridColumnMovingMethods;
}

interface JQuery {
	igGridColumnMoving(methodName: "destroy"): void;
	igGridColumnMoving(methodName: "moveColumn", column: Object, target: Object, after?: boolean, inDom?: boolean, callback?: Function): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnSettings"): IgGridColumnMovingColumnSetting[];
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridColumnMovingColumnSetting[]): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "mode"): any;
	igGridColumnMoving(optionLiteral: 'option', optionName: "mode", optionValue: any): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "moveType"): any;
	igGridColumnMoving(optionLiteral: 'option', optionName: "moveType", optionValue: any): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "addMovingDropdown"): boolean;
	igGridColumnMoving(optionLiteral: 'option', optionName: "addMovingDropdown", optionValue: boolean): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogWidth"): number;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogWidth", optionValue: number): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogHeight"): number;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogHeight", optionValue: number): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogAnimationDuration"): number;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogAnimationDuration", optionValue: number): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingAcceptanceTolerance"): number;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingAcceptanceTolerance", optionValue: number): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingScrollTolerance"): number;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingScrollTolerance", optionValue: number): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "scrollSpeedMultiplier"): number;
	igGridColumnMoving(optionLiteral: 'option', optionName: "scrollSpeedMultiplier", optionValue: number): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "scrollDelta"): number;
	igGridColumnMoving(optionLiteral: 'option', optionName: "scrollDelta", optionValue: number): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "hideHeaderContentsDuringDrag"): boolean;
	igGridColumnMoving(optionLiteral: 'option', optionName: "hideHeaderContentsDuringDrag", optionValue: boolean): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "dragHelperOpacity"): number;
	igGridColumnMoving(optionLiteral: 'option', optionName: "dragHelperOpacity", optionValue: number): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogCaptionButtonDesc"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogCaptionButtonDesc", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogCaptionButtonAsc"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogCaptionButtonAsc", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogCaptionText"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogCaptionText", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDisplayText"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDisplayText", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDropTooltipText"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDropTooltipText", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDropTooltipMarkup"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDropTooltipMarkup", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "dropDownMoveLeftText"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "dropDownMoveLeftText", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "dropDownMoveRightText"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "dropDownMoveRightText", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "dropDownMoveFirstText"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "dropDownMoveFirstText", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "dropDownMoveLastText"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "dropDownMoveLastText", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingToolTipMove"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingToolTipMove", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "featureChooserSubmenuText"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "featureChooserSubmenuText", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnMovingDialogContainment"): string;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnMovingDialogContainment", optionValue: string): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridColumnMoving(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnDragStart"): ColumnDragStartEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnDragStart", optionValue: ColumnDragStartEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnDragEnd"): ColumnDragEndEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnDragEnd", optionValue: ColumnDragEndEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnDragCanceled"): ColumnDragCanceledEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnDragCanceled", optionValue: ColumnDragCanceledEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnMoving"): ColumnMovingEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnMoving", optionValue: ColumnMovingEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnMoved"): ColumnMovedEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "columnMoved", optionValue: ColumnMovedEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogOpening"): MovingDialogOpeningEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogOpening", optionValue: MovingDialogOpeningEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogOpened"): MovingDialogOpenedEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogOpened", optionValue: MovingDialogOpenedEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDragged"): MovingDialogDraggedEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDragged", optionValue: MovingDialogDraggedEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogClosing"): MovingDialogClosingEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogClosing", optionValue: MovingDialogClosingEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogClosed"): MovingDialogClosedEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogClosed", optionValue: MovingDialogClosedEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogContentsRendering"): MovingDialogContentsRenderingEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogContentsRendering", optionValue: MovingDialogContentsRenderingEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogContentsRendered"): MovingDialogContentsRenderedEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogContentsRendered", optionValue: MovingDialogContentsRenderedEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogMoveUpButtonPressed"): MovingDialogMoveUpButtonPressedEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogMoveUpButtonPressed", optionValue: MovingDialogMoveUpButtonPressedEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogMoveDownButtonPressed"): MovingDialogMoveDownButtonPressedEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogMoveDownButtonPressed", optionValue: MovingDialogMoveDownButtonPressedEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDragColumnMoving"): MovingDialogDragColumnMovingEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDragColumnMoving", optionValue: MovingDialogDragColumnMovingEvent): void;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDragColumnMoved"): MovingDialogDragColumnMovedEvent;
	igGridColumnMoving(optionLiteral: 'option', optionName: "movingDialogDragColumnMoved", optionValue: MovingDialogDragColumnMovedEvent): void;
	igGridColumnMoving(options: IgGridColumnMoving): JQuery;
	igGridColumnMoving(optionLiteral: 'option', optionName: string): any;
	igGridColumnMoving(optionLiteral: 'option', options: IgGridColumnMoving): JQuery;
	igGridColumnMoving(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridColumnMoving(methodName: string, ...methodParams: any[]): any;
}
interface IgPopoverHeaderTemplate {
	closeButton?: boolean;
	title?: string;
}

interface ShowingEvent {
	(event: Event, ui: ShowingEventUIParam): void;
}

interface ShowingEventUIParam {
	element?: any;
	content?: any;
	popover?: any;
	owner?: any;
}

interface ShownEvent {
	(event: Event, ui: ShownEventUIParam): void;
}

interface ShownEventUIParam {
	element?: any;
	content?: any;
	popover?: any;
	owner?: any;
}

interface HidingEvent {
	(event: Event, ui: HidingEventUIParam): void;
}

interface HidingEventUIParam {
	element?: any;
	content?: any;
	popover?: any;
	owner?: any;
}

interface HiddenEvent {
	(event: Event, ui: HiddenEventUIParam): void;
}

interface HiddenEventUIParam {
	element?: any;
	content?: any;
	popover?: any;
	owner?: any;
}

interface IgGridFeatureChooserPopover {
	gridId?: string;
	targetButton?: any;
	closeOnBlur?: boolean;
	containment?: any;
	closeOnBlur?: boolean;
	direction?: any;
	position?: any;
	width?: any;
	height?: any;
	minWidth?: any;
	maxWidth?: any;
	maxHeight?: any;
	animationDuration?: number;
	contentTemplate?: any;
	selectors?: string;
	headerTemplate?: IgPopoverHeaderTemplate;
	showOn?: any;
	containment?: any;
	showing?: ShowingEvent;
	shown?: ShownEvent;
	hiding?: HidingEvent;
	hidden?: HiddenEvent;
}
interface IgGridFeatureChooserPopoverMethods {
	isShown(): void;
	registerElements(elements: Object): void;
	destroy(): void;
	id(): string;
	container(): Object;
	show(trg?: Element, content?: string): void;
	hide(): void;
	getContent(): string;
	setContent(newCnt: string): void;
	target(): Object;
	getCoordinates(): Object;
	setCoordinates(pos: Object): void;
}
interface JQuery {
	data(propertyName: "igGridFeatureChooserPopover"):IgGridFeatureChooserPopoverMethods;
}

interface FeatureChooserRenderingEvent {
	(event: Event, ui: FeatureChooserRenderingEventUIParam): void;
}

interface FeatureChooserRenderingEventUIParam {
}

interface FeatureChooserRenderedEvent {
	(event: Event, ui: FeatureChooserRenderedEventUIParam): void;
}

interface FeatureChooserRenderedEventUIParam {
}

interface FeatureChooserDropDownOpeningEvent {
	(event: Event, ui: FeatureChooserDropDownOpeningEventUIParam): void;
}

interface FeatureChooserDropDownOpeningEventUIParam {
}

interface FeatureChooserDropDownOpenedEvent {
	(event: Event, ui: FeatureChooserDropDownOpenedEventUIParam): void;
}

interface FeatureChooserDropDownOpenedEventUIParam {
}

interface MenuTogglingEvent {
	(event: Event, ui: MenuTogglingEventUIParam): void;
}

interface MenuTogglingEventUIParam {
}

interface FeatureTogglingEvent {
	(event: Event, ui: FeatureTogglingEventUIParam): void;
}

interface FeatureTogglingEventUIParam {
}

interface FeatureToggledEvent {
	(event: Event, ui: FeatureToggledEventUIParam): void;
}

interface FeatureToggledEventUIParam {
}

interface IgGridFeatureChooser {
	dropDownWidth?: any;
	animationDuration?: number;
	featureChooserRendering?: FeatureChooserRenderingEvent;
	featureChooserRendered?: FeatureChooserRenderedEvent;
	featureChooserDropDownOpening?: FeatureChooserDropDownOpeningEvent;
	featureChooserDropDownOpened?: FeatureChooserDropDownOpenedEvent;
	menuToggling?: MenuTogglingEvent;
	featureToggling?: FeatureTogglingEvent;
	featureToggled?: FeatureToggledEvent;
}
interface IgGridFeatureChooserMethods {
	shouldShowFeatureIcon(key: Object): void;
	showDropDown(columnKey: string): void;
	hideDropDown(columnKey: string): void;
	getDropDownByColumnKey(columnKey: string): void;
	toggleDropDown(columnKey: string): void;
	destroy(e: Object, args: Object): void;
}
interface JQuery {
	data(propertyName: "igGridFeatureChooser"):IgGridFeatureChooserMethods;
}

interface ModalDialogOpeningEvent {
	(event: Event, ui: ModalDialogOpeningEventUIParam): void;
}

interface ModalDialogOpeningEventUIParam {
	owner?: any;
}

interface ModalDialogOpenedEvent {
	(event: Event, ui: ModalDialogOpenedEventUIParam): void;
}

interface ModalDialogOpenedEventUIParam {
	owner?: any;
	modalDialog?: any;
}

interface ModalDialogMovingEvent {
	(event: Event, ui: ModalDialogMovingEventUIParam): void;
}

interface ModalDialogMovingEventUIParam {
	owner?: any;
	modalDialog?: any;
	originalPosition?: any;
	position?: any;
}

interface ModalDialogClosingEvent {
	(event: Event, ui: ModalDialogClosingEventUIParam): void;
}

interface ModalDialogClosingEventUIParam {
	owner?: any;
	modalDialog?: any;
}

interface ModalDialogClosedEvent {
	(event: Event, ui: ModalDialogClosedEventUIParam): void;
}

interface ModalDialogClosedEventUIParam {
	owner?: any;
	modalDialog?: any;
}

interface ModalDialogContentsRenderingEvent {
	(event: Event, ui: ModalDialogContentsRenderingEventUIParam): void;
}

interface ModalDialogContentsRenderingEventUIParam {
	owner?: any;
	modalDialog?: any;
}

interface ModalDialogContentsRenderedEvent {
	(event: Event, ui: ModalDialogContentsRenderedEventUIParam): void;
}

interface ModalDialogContentsRenderedEventUIParam {
	owner?: any;
	modalDialog?: any;
}

interface ButtonOKClickEvent {
	(event: Event, ui: ButtonOKClickEventUIParam): void;
}

interface ButtonOKClickEventUIParam {
	owner?: any;
	modalDialog?: any;
}

interface IgGridModalDialog {
	buttonApplyText?: string;
	buttonCancelText?: string;
	modalDialogCaptionText?: string;
	modalDialogWidth?: number;
	modalDialogHeight?: number;
	renderFooterButtons?: boolean;
	animationDuration?: number;
	modalDialogOpening?: ModalDialogOpeningEvent;
	modalDialogOpened?: ModalDialogOpenedEvent;
	modalDialogMoving?: ModalDialogMovingEvent;
	modalDialogClosing?: ModalDialogClosingEvent;
	modalDialogClosed?: ModalDialogClosedEvent;
	modalDialogContentsRendering?: ModalDialogContentsRenderingEvent;
	modalDialogContentsRendered?: ModalDialogContentsRenderedEvent;
	buttonOKClick?: ButtonOKClickEvent;
}
interface IgGridModalDialogMethods {
	openModalDialog(): void;
	closeModalDialog(): void;
	getCaptionButtonContainer(): void;
	getFooter(): void;
	getContent(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igGridModalDialog"):IgGridModalDialogMethods;
}

interface JQuery {
	igGridFeatureChooserPopover(methodName: "isShown"): void;
	igGridFeatureChooserPopover(methodName: "registerElements", elements: Object): void;
	igGridFeatureChooserPopover(methodName: "destroy"): void;
	igGridFeatureChooserPopover(methodName: "id"): string;
	igGridFeatureChooserPopover(methodName: "container"): Object;
	igGridFeatureChooserPopover(methodName: "show", trg?: Element, content?: string): void;
	igGridFeatureChooserPopover(methodName: "hide"): void;
	igGridFeatureChooserPopover(methodName: "getContent"): string;
	igGridFeatureChooserPopover(methodName: "setContent", newCnt: string): void;
	igGridFeatureChooserPopover(methodName: "target"): Object;
	igGridFeatureChooserPopover(methodName: "getCoordinates"): Object;
	igGridFeatureChooserPopover(methodName: "setCoordinates", pos: Object): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "gridId"): string;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "gridId", optionValue: string): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "targetButton"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "targetButton", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "closeOnBlur"): boolean;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "closeOnBlur", optionValue: boolean): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "containment"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "containment", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "closeOnBlur"): boolean;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "closeOnBlur", optionValue: boolean): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "direction"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "direction", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "position"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "position", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "width"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "height"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "minWidth"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "minWidth", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "maxWidth"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "maxWidth", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "maxHeight"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "maxHeight", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "animationDuration"): number;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "animationDuration", optionValue: number): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "contentTemplate"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "contentTemplate", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "selectors"): string;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "selectors", optionValue: string): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "headerTemplate"): IgPopoverHeaderTemplate;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "headerTemplate", optionValue: IgPopoverHeaderTemplate): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "showOn"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "showOn", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "containment"): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "containment", optionValue: any): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "showing"): ShowingEvent;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "showing", optionValue: ShowingEvent): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "shown"): ShownEvent;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "shown", optionValue: ShownEvent): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "hiding"): HidingEvent;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "hiding", optionValue: HidingEvent): void;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "hidden"): HiddenEvent;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: "hidden", optionValue: HiddenEvent): void;
	igGridFeatureChooserPopover(options: IgGridFeatureChooserPopover): JQuery;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: string): any;
	igGridFeatureChooserPopover(optionLiteral: 'option', options: IgGridFeatureChooserPopover): JQuery;
	igGridFeatureChooserPopover(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridFeatureChooserPopover(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igGridFeatureChooser(methodName: "shouldShowFeatureIcon", key: Object): void;
	igGridFeatureChooser(methodName: "showDropDown", columnKey: string): void;
	igGridFeatureChooser(methodName: "hideDropDown", columnKey: string): void;
	igGridFeatureChooser(methodName: "getDropDownByColumnKey", columnKey: string): void;
	igGridFeatureChooser(methodName: "toggleDropDown", columnKey: string): void;
	igGridFeatureChooser(methodName: "destroy", e: Object, args: Object): void;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "dropDownWidth"): any;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "dropDownWidth", optionValue: any): void;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "animationDuration"): number;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "animationDuration", optionValue: number): void;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureChooserRendering"): FeatureChooserRenderingEvent;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureChooserRendering", optionValue: FeatureChooserRenderingEvent): void;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureChooserRendered"): FeatureChooserRenderedEvent;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureChooserRendered", optionValue: FeatureChooserRenderedEvent): void;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureChooserDropDownOpening"): FeatureChooserDropDownOpeningEvent;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureChooserDropDownOpening", optionValue: FeatureChooserDropDownOpeningEvent): void;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureChooserDropDownOpened"): FeatureChooserDropDownOpenedEvent;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureChooserDropDownOpened", optionValue: FeatureChooserDropDownOpenedEvent): void;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "menuToggling"): MenuTogglingEvent;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "menuToggling", optionValue: MenuTogglingEvent): void;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureToggling"): FeatureTogglingEvent;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureToggling", optionValue: FeatureTogglingEvent): void;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureToggled"): FeatureToggledEvent;
	igGridFeatureChooser(optionLiteral: 'option', optionName: "featureToggled", optionValue: FeatureToggledEvent): void;
	igGridFeatureChooser(options: IgGridFeatureChooser): JQuery;
	igGridFeatureChooser(optionLiteral: 'option', optionName: string): any;
	igGridFeatureChooser(optionLiteral: 'option', options: IgGridFeatureChooser): JQuery;
	igGridFeatureChooser(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridFeatureChooser(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igGridModalDialog(methodName: "openModalDialog"): void;
	igGridModalDialog(methodName: "closeModalDialog"): void;
	igGridModalDialog(methodName: "getCaptionButtonContainer"): void;
	igGridModalDialog(methodName: "getFooter"): void;
	igGridModalDialog(methodName: "getContent"): void;
	igGridModalDialog(methodName: "destroy"): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "buttonApplyText"): string;
	igGridModalDialog(optionLiteral: 'option', optionName: "buttonApplyText", optionValue: string): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "buttonCancelText"): string;
	igGridModalDialog(optionLiteral: 'option', optionName: "buttonCancelText", optionValue: string): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogCaptionText"): string;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogCaptionText", optionValue: string): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogWidth"): number;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogWidth", optionValue: number): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogHeight"): number;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogHeight", optionValue: number): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "renderFooterButtons"): boolean;
	igGridModalDialog(optionLiteral: 'option', optionName: "renderFooterButtons", optionValue: boolean): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "animationDuration"): number;
	igGridModalDialog(optionLiteral: 'option', optionName: "animationDuration", optionValue: number): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogOpening"): ModalDialogOpeningEvent;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogOpening", optionValue: ModalDialogOpeningEvent): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogOpened"): ModalDialogOpenedEvent;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogOpened", optionValue: ModalDialogOpenedEvent): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogMoving"): ModalDialogMovingEvent;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogMoving", optionValue: ModalDialogMovingEvent): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogClosing"): ModalDialogClosingEvent;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogClosing", optionValue: ModalDialogClosingEvent): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogClosed"): ModalDialogClosedEvent;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogClosed", optionValue: ModalDialogClosedEvent): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogContentsRendering"): ModalDialogContentsRenderingEvent;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogContentsRendering", optionValue: ModalDialogContentsRenderingEvent): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogContentsRendered"): ModalDialogContentsRenderedEvent;
	igGridModalDialog(optionLiteral: 'option', optionName: "modalDialogContentsRendered", optionValue: ModalDialogContentsRenderedEvent): void;
	igGridModalDialog(optionLiteral: 'option', optionName: "buttonOKClick"): ButtonOKClickEvent;
	igGridModalDialog(optionLiteral: 'option', optionName: "buttonOKClick", optionValue: ButtonOKClickEvent): void;
	igGridModalDialog(options: IgGridModalDialog): JQuery;
	igGridModalDialog(optionLiteral: 'option', optionName: string): any;
	igGridModalDialog(optionLiteral: 'option', options: IgGridModalDialog): JQuery;
	igGridModalDialog(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridModalDialog(methodName: string, ...methodParams: any[]): any;
}
interface IgGridFilteringColumnSettingDefaultExpressions {
}

interface IgGridFilteringColumnSetting {
	columnKey?: string;
	columnIndex?: number;
	allowFiltering?: boolean;
	condition?: any;
	defaultExpressions?: IgGridFilteringColumnSettingDefaultExpressions;
}

interface IgGridFilteringNullTexts {
	startsWith?: string;
	endsWith?: string;
	contains?: string;
	doesNotContain?: string;
	equals?: string;
	doesNotEqual?: string;
	greaterThan?: string;
	lessThan?: string;
	greaterThanOrEqualTo?: string;
	lessThanOrEqualTo?: string;
	on?: string;
	notOn?: string;
	after?: string;
	before?: string;
	thisMonth?: string;
	lastMonth?: string;
	nextMonth?: string;
	thisYear?: string;
	lastYear?: string;
	nextYear?: string;
	empty?: string;
	notEmpty?: string;
	null?: string;
	notNull?: string;
}

interface IgGridFilteringLabels {
	noFilter?: string;
	clear?: string;
	startsWith?: string;
	endsWith?: string;
	contains?: string;
	doesNotContain?: string;
	equals?: string;
	doesNotEqual?: string;
	greaterThan?: string;
	lessThan?: string;
	greaterThanOrEqualTo?: string;
	lessThanOrEqualTo?: string;
	trueLabel?: string;
	falseLabel?: string;
	after?: string;
	before?: string;
	today?: string;
	yesterday?: string;
	thisMonth?: string;
	lastMonth?: string;
	nextMonth?: string;
	thisYear?: string;
	lastYear?: string;
	nextYear?: string;
	on?: string;
	notOn?: string;
	advancedButtonLabel?: string;
	filterDialogCaptionLabel?: string;
	filterDialogConditionLabel1?: string;
	filterDialogConditionLabel2?: string;
	filterDialogOkLabel?: string;
	filterDialogCancelLabel?: string;
	filterDialogAnyLabel?: string;
	filterDialogAllLabel?: string;
	filterDialogAddLabel?: string;
	filterDialogErrorLabel?: string;
	filterSummaryTitleLabel?: string;
	filterDialogClearAllLabel?: string;
	empty?: string;
	notEmpty?: string;
	nullLabel?: string;
	notNull?: string;
	true?: string;
	false?: string;
}

interface DataFilteringEvent {
	(event: Event, ui: DataFilteringEventUIParam): void;
}

interface DataFilteringEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
	newExpressions?: any;
}

interface DataFilteredEvent {
	(event: Event, ui: DataFilteredEventUIParam): void;
}

interface DataFilteredEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
	expressions?: any;
}

interface FilterDialogOpeningEvent {
	(event: Event, ui: FilterDialogOpeningEventUIParam): void;
}

interface FilterDialogOpeningEventUIParam {
	owner?: any;
	dialog?: any;
}

interface FilterDialogOpenedEvent {
	(event: Event, ui: FilterDialogOpenedEventUIParam): void;
}

interface FilterDialogOpenedEventUIParam {
	owner?: any;
	dialog?: any;
}

interface FilterDialogMovingEvent {
	(event: Event, ui: FilterDialogMovingEventUIParam): void;
}

interface FilterDialogMovingEventUIParam {
	owner?: any;
	dialog?: any;
	originalPosition?: any;
	position?: any;
}

interface FilterDialogFilterAddingEvent {
	(event: Event, ui: FilterDialogFilterAddingEventUIParam): void;
}

interface FilterDialogFilterAddingEventUIParam {
	owner?: any;
	filtersTableBody?: any;
}

interface FilterDialogFilterAddedEvent {
	(event: Event, ui: FilterDialogFilterAddedEventUIParam): void;
}

interface FilterDialogFilterAddedEventUIParam {
	owner?: any;
	filter?: any;
}

interface FilterDialogClosingEvent {
	(event: Event, ui: FilterDialogClosingEventUIParam): void;
}

interface FilterDialogClosingEventUIParam {
	owner?: any;
}

interface FilterDialogClosedEvent {
	(event: Event, ui: FilterDialogClosedEventUIParam): void;
}

interface FilterDialogClosedEventUIParam {
	owner?: any;
}

interface FilterDialogContentsRenderingEvent {
	(event: Event, ui: FilterDialogContentsRenderingEventUIParam): void;
}

interface FilterDialogContentsRenderingEventUIParam {
	owner?: any;
	dialogElement?: any;
}

interface FilterDialogContentsRenderedEvent {
	(event: Event, ui: FilterDialogContentsRenderedEventUIParam): void;
}

interface FilterDialogContentsRenderedEventUIParam {
	owner?: any;
	dialogElement?: any;
}

interface FilterDialogFilteringEvent {
	(event: Event, ui: FilterDialogFilteringEventUIParam): void;
}

interface FilterDialogFilteringEventUIParam {
	owner?: any;
	dialog?: any;
}

interface IgGridFiltering {
	caseSensitive?: boolean;
	filterSummaryAlwaysVisible?: boolean;
	renderFC?: boolean;
	filterSummaryTemplate?: string;
	filterDropDownAnimations?: any;
	filterDropDownAnimationDuration?: number;
	filterDropDownWidth?: any;
	filterDropDownHeight?: any;
	filterExprUrlKey?: string;
	filterDropDownItemIcons?: any;
	columnSettings?: IgGridFilteringColumnSetting[];
	type?: any;
	filterDelay?: number;
	mode?: any;
	advancedModeEditorsVisible?: boolean;
	advancedModeHeaderButtonLocation?: any;
	filterDialogWidth?: any;
	filterDialogHeight?: any;
	filterDialogFilterDropDownDefaultWidth?: any;
	filterDialogExprInputDefaultWidth?: any;
	filterDialogColumnDropDownDefaultWidth?: any;
	renderFilterButton?: boolean;
	filterButtonLocation?: any;
	nullTexts?: IgGridFilteringNullTexts;
	labels?: IgGridFilteringLabels;
	tooltipTemplate?: string;
	filterDialogAddConditionTemplate?: string;
	filterDialogAddConditionDropDownTemplate?: string;
	filterDialogFilterTemplate?: string;
	filterDialogFilterConditionTemplate?: string;
	filterDialogAddButtonWidth?: any;
	filterDialogOkCancelButtonWidth?: any;
	filterDialogMaxFilterCount?: number;
	filterDialogContainment?: string;
	showEmptyConditions?: boolean;
	showNullConditions?: boolean;
	featureChooserText?: string;
	featureChooserTextHide?: string;
	featureChooserTextAdvancedFilter?: string;
	persist?: boolean;
	inherit?: boolean;
	dataFiltering?: DataFilteringEvent;
	dataFiltered?: DataFilteredEvent;
	dropDownOpening?: DropDownOpeningEvent;
	dropDownOpened?: DropDownOpenedEvent;
	dropDownClosing?: DropDownClosingEvent;
	dropDownClosed?: DropDownClosedEvent;
	filterDialogOpening?: FilterDialogOpeningEvent;
	filterDialogOpened?: FilterDialogOpenedEvent;
	filterDialogMoving?: FilterDialogMovingEvent;
	filterDialogFilterAdding?: FilterDialogFilterAddingEvent;
	filterDialogFilterAdded?: FilterDialogFilterAddedEvent;
	filterDialogClosing?: FilterDialogClosingEvent;
	filterDialogClosed?: FilterDialogClosedEvent;
	filterDialogContentsRendering?: FilterDialogContentsRenderingEvent;
	filterDialogContentsRendered?: FilterDialogContentsRenderedEvent;
	filterDialogFiltering?: FilterDialogFilteringEvent;
}
interface IgGridFilteringMethods {
	destroy(): void;
	getFilteringMatchesCount(): number;
	toggleFilterRowByFeatureChooser(event: string): void;
	filter(expressions: any[], updateUI?: boolean, addedFromAdvanced?: boolean): void;
	requiresFilteringExpression(filterCondition: string): boolean;
}
interface JQuery {
	data(propertyName: "igGridFiltering"):IgGridFilteringMethods;
}

interface JQuery {
	igGridFiltering(methodName: "destroy"): void;
	igGridFiltering(methodName: "getFilteringMatchesCount"): number;
	igGridFiltering(methodName: "toggleFilterRowByFeatureChooser", event: string): void;
	igGridFiltering(methodName: "filter", expressions: any[], updateUI?: boolean, addedFromAdvanced?: boolean): void;
	igGridFiltering(methodName: "requiresFilteringExpression", filterCondition: string): boolean;
	igGridFiltering(optionLiteral: 'option', optionName: "caseSensitive"): boolean;
	igGridFiltering(optionLiteral: 'option', optionName: "caseSensitive", optionValue: boolean): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterSummaryAlwaysVisible"): boolean;
	igGridFiltering(optionLiteral: 'option', optionName: "filterSummaryAlwaysVisible", optionValue: boolean): void;
	igGridFiltering(optionLiteral: 'option', optionName: "renderFC"): boolean;
	igGridFiltering(optionLiteral: 'option', optionName: "renderFC", optionValue: boolean): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterSummaryTemplate"): string;
	igGridFiltering(optionLiteral: 'option', optionName: "filterSummaryTemplate", optionValue: string): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDropDownAnimations"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDropDownAnimations", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDropDownAnimationDuration"): number;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDropDownAnimationDuration", optionValue: number): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDropDownWidth"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDropDownWidth", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDropDownHeight"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDropDownHeight", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterExprUrlKey"): string;
	igGridFiltering(optionLiteral: 'option', optionName: "filterExprUrlKey", optionValue: string): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDropDownItemIcons"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDropDownItemIcons", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "columnSettings"): IgGridFilteringColumnSetting[];
	igGridFiltering(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridFilteringColumnSetting[]): void;
	igGridFiltering(optionLiteral: 'option', optionName: "type"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDelay"): number;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDelay", optionValue: number): void;
	igGridFiltering(optionLiteral: 'option', optionName: "mode"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "mode", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "advancedModeEditorsVisible"): boolean;
	igGridFiltering(optionLiteral: 'option', optionName: "advancedModeEditorsVisible", optionValue: boolean): void;
	igGridFiltering(optionLiteral: 'option', optionName: "advancedModeHeaderButtonLocation"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "advancedModeHeaderButtonLocation", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogWidth"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogWidth", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogHeight"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogHeight", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterDropDownDefaultWidth"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterDropDownDefaultWidth", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogExprInputDefaultWidth"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogExprInputDefaultWidth", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogColumnDropDownDefaultWidth"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogColumnDropDownDefaultWidth", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "renderFilterButton"): boolean;
	igGridFiltering(optionLiteral: 'option', optionName: "renderFilterButton", optionValue: boolean): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterButtonLocation"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterButtonLocation", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "nullTexts"): IgGridFilteringNullTexts;
	igGridFiltering(optionLiteral: 'option', optionName: "nullTexts", optionValue: IgGridFilteringNullTexts): void;
	igGridFiltering(optionLiteral: 'option', optionName: "labels"): IgGridFilteringLabels;
	igGridFiltering(optionLiteral: 'option', optionName: "labels", optionValue: IgGridFilteringLabels): void;
	igGridFiltering(optionLiteral: 'option', optionName: "tooltipTemplate"): string;
	igGridFiltering(optionLiteral: 'option', optionName: "tooltipTemplate", optionValue: string): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddConditionTemplate"): string;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddConditionTemplate", optionValue: string): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddConditionDropDownTemplate"): string;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddConditionDropDownTemplate", optionValue: string): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterTemplate"): string;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterTemplate", optionValue: string): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterConditionTemplate"): string;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterConditionTemplate", optionValue: string): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddButtonWidth"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddButtonWidth", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogOkCancelButtonWidth"): any;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogOkCancelButtonWidth", optionValue: any): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogMaxFilterCount"): number;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogMaxFilterCount", optionValue: number): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogContainment"): string;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogContainment", optionValue: string): void;
	igGridFiltering(optionLiteral: 'option', optionName: "showEmptyConditions"): boolean;
	igGridFiltering(optionLiteral: 'option', optionName: "showEmptyConditions", optionValue: boolean): void;
	igGridFiltering(optionLiteral: 'option', optionName: "showNullConditions"): boolean;
	igGridFiltering(optionLiteral: 'option', optionName: "showNullConditions", optionValue: boolean): void;
	igGridFiltering(optionLiteral: 'option', optionName: "featureChooserText"): string;
	igGridFiltering(optionLiteral: 'option', optionName: "featureChooserText", optionValue: string): void;
	igGridFiltering(optionLiteral: 'option', optionName: "featureChooserTextHide"): string;
	igGridFiltering(optionLiteral: 'option', optionName: "featureChooserTextHide", optionValue: string): void;
	igGridFiltering(optionLiteral: 'option', optionName: "featureChooserTextAdvancedFilter"): string;
	igGridFiltering(optionLiteral: 'option', optionName: "featureChooserTextAdvancedFilter", optionValue: string): void;
	igGridFiltering(optionLiteral: 'option', optionName: "persist"): boolean;
	igGridFiltering(optionLiteral: 'option', optionName: "persist", optionValue: boolean): void;
	igGridFiltering(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridFiltering(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridFiltering(optionLiteral: 'option', optionName: "dataFiltering"): DataFilteringEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "dataFiltering", optionValue: DataFilteringEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "dataFiltered"): DataFilteredEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "dataFiltered", optionValue: DataFilteredEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "dropDownOpening"): DropDownOpeningEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "dropDownOpening", optionValue: DropDownOpeningEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "dropDownOpened"): DropDownOpenedEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "dropDownOpened", optionValue: DropDownOpenedEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "dropDownClosing"): DropDownClosingEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "dropDownClosing", optionValue: DropDownClosingEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "dropDownClosed"): DropDownClosedEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "dropDownClosed", optionValue: DropDownClosedEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogOpening"): FilterDialogOpeningEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogOpening", optionValue: FilterDialogOpeningEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogOpened"): FilterDialogOpenedEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogOpened", optionValue: FilterDialogOpenedEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogMoving"): FilterDialogMovingEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogMoving", optionValue: FilterDialogMovingEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterAdding"): FilterDialogFilterAddingEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterAdding", optionValue: FilterDialogFilterAddingEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterAdded"): FilterDialogFilterAddedEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterAdded", optionValue: FilterDialogFilterAddedEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogClosing"): FilterDialogClosingEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogClosing", optionValue: FilterDialogClosingEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogClosed"): FilterDialogClosedEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogClosed", optionValue: FilterDialogClosedEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogContentsRendering"): FilterDialogContentsRenderingEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogContentsRendering", optionValue: FilterDialogContentsRenderingEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogContentsRendered"): FilterDialogContentsRenderedEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogContentsRendered", optionValue: FilterDialogContentsRenderedEvent): void;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFiltering"): FilterDialogFilteringEvent;
	igGridFiltering(optionLiteral: 'option', optionName: "filterDialogFiltering", optionValue: FilterDialogFilteringEvent): void;
	igGridFiltering(options: IgGridFiltering): JQuery;
	igGridFiltering(optionLiteral: 'option', optionName: string): any;
	igGridFiltering(optionLiteral: 'option', options: IgGridFiltering): JQuery;
	igGridFiltering(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridFiltering(methodName: string, ...methodParams: any[]): any;
}
interface IgGridColumn {
	headerText?: string;
	key?: string;
	formatter?: any;
	format?: string;
	dataType?: any;
	width?: any;
	hidden?: boolean;
	template?: string;
	unbound?: boolean;
	group?: any[];
	rowspan?: number;
	formula?: any;
	unboundValues?: any[];
	unboundValuesUpdateMode?: any;
	headerCssClass?: string;
	columnCssClass?: string;
}

interface IgGridFeatures {
}

interface IgGridRestSettingsCreate {
	url?: string;
	template?: string;
	batch?: boolean;
}

interface IgGridRestSettingsUpdate {
	url?: string;
	template?: string;
	batch?: boolean;
}

interface IgGridRestSettingsRemove {
	url?: string;
	template?: string;
	batch?: boolean;
}

interface IgGridRestSettings {
	create?: IgGridRestSettingsCreate;
	update?: IgGridRestSettingsUpdate;
	remove?: IgGridRestSettingsRemove;
	encodeRemoveInRequestUri?: boolean;
	contentSerializer?: Function;
	contentType?: string;
}

interface CellClickEvent {
	(event: Event, ui: CellClickEventUIParam): void;
}

interface CellClickEventUIParam {
	cellElement?: any;
	rowIndex?: any;
	rowKey?: any;
	colIndex?: any;
	colKey?: any;
	owner?: any;
}

interface CellRightClickEvent {
	(event: Event, ui: CellRightClickEventUIParam): void;
}

interface CellRightClickEventUIParam {
	cellElement?: any;
	rowIndex?: any;
	rowKey?: any;
	colIndex?: any;
	colKey?: any;
	row?: any;
	owner?: any;
}

interface RenderingEvent {
	(event: Event, ui: RenderingEventUIParam): void;
}

interface RenderingEventUIParam {
	owner?: any;
}

interface DataRenderingEvent {
	(event: Event, ui: DataRenderingEventUIParam): void;
}

interface DataRenderingEventUIParam {
	owner?: any;
}

interface DataRenderedEvent {
	(event: Event, ui: DataRenderedEventUIParam): void;
}

interface DataRenderedEventUIParam {
	owner?: any;
}

interface HeaderRenderingEvent {
	(event: Event, ui: HeaderRenderingEventUIParam): void;
}

interface HeaderRenderingEventUIParam {
	owner?: any;
}

interface HeaderRenderedEvent {
	(event: Event, ui: HeaderRenderedEventUIParam): void;
}

interface HeaderRenderedEventUIParam {
	owner?: any;
	table?: any;
}

interface FooterRenderingEvent {
	(event: Event, ui: FooterRenderingEventUIParam): void;
}

interface FooterRenderingEventUIParam {
	owner?: any;
}

interface FooterRenderedEvent {
	(event: Event, ui: FooterRenderedEventUIParam): void;
}

interface FooterRenderedEventUIParam {
	owner?: any;
	table?: any;
}

interface HeaderCellRenderedEvent {
	(event: Event, ui: HeaderCellRenderedEventUIParam): void;
}

interface HeaderCellRenderedEventUIParam {
	owner?: any;
	columnKey?: any;
	th?: any;
}

interface RowsRenderingEvent {
	(event: Event, ui: RowsRenderingEventUIParam): void;
}

interface RowsRenderingEventUIParam {
	owner?: any;
	tbody?: any;
}

interface RowsRenderedEvent {
	(event: Event, ui: RowsRenderedEventUIParam): void;
}

interface RowsRenderedEventUIParam {
	owner?: any;
	tbody?: any;
}

interface SchemaGeneratedEvent {
	(event: Event, ui: SchemaGeneratedEventUIParam): void;
}

interface SchemaGeneratedEventUIParam {
	owner?: any;
	schema?: any;
	dataSource?: any;
}

interface ColumnsCollectionModifiedEvent {
	(event: Event, ui: ColumnsCollectionModifiedEventUIParam): void;
}

interface ColumnsCollectionModifiedEventUIParam {
	owner?: any;
}

interface RequestErrorEvent {
	(event: Event, ui: RequestErrorEventUIParam): void;
}

interface RequestErrorEventUIParam {
	owner?: any;
	message?: any;
	response?: any;
}

interface CreatedEvent {
	(event: Event, ui: CreatedEventUIParam): void;
}

interface CreatedEventUIParam {
	owner?: any;
}

interface DestroyedEvent {
	(event: Event, ui: DestroyedEventUIParam): void;
}

interface DestroyedEventUIParam {
	owner?: any;
}

interface IgGrid {
	width?: any;
	height?: any;
	autoAdjustHeight?: boolean;
	avgRowHeight?: any;
	avgColumnWidth?: any;
	defaultColumnWidth?: any;
	autoGenerateColumns?: boolean;
	virtualization?: boolean;
	virtualizationMode?: any;
	requiresDataBinding?: boolean;
	rowVirtualization?: boolean;
	columnVirtualization?: boolean;
	virtualizationMouseWheelStep?: number;
	adjustVirtualHeights?: boolean;
	rowTemplate?: string;
	jQueryTemplating?: boolean;
	templatingEngine?: any;
	columns?: IgGridColumn[];
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	responseTotalRecCountKey?: string;
	requestType?: string;
	responseContentType?: string;
	showHeader?: boolean;
	showFooter?: boolean;
	fixedHeaders?: boolean;
	fixedFooters?: boolean;
	caption?: string;
	features?: IgGridFeatures;
	tabIndex?: number;
	accessibilityRendering?: boolean;
	localSchemaTransform?: boolean;
	primaryKey?: string;
	serializeTransactionLog?: boolean;
	autoCommit?: boolean;
	aggregateTransactions?: boolean;
	autoFormat?: any;
	renderCheckboxes?: boolean;
	updateUrl?: string;
	restSettings?: IgGridRestSettings;
	alternateRowStyles?: boolean;
	autofitLastColumn?: boolean;
	enableHoverStyles?: boolean;
	enableUTCDates?: boolean;
	mergeUnboundColumns?: boolean;
	jsonpRequest?: boolean;
	enableResizeContainerCheck?: boolean;
	featureChooserIconDisplay?: any;
	cellClick?: CellClickEvent;
	cellRightClick?: CellRightClickEvent;
	dataBinding?: DataBindingEvent;
	dataBound?: DataBoundEvent;
	rendering?: RenderingEvent;
	rendered?: RenderedEvent;
	dataRendering?: DataRenderingEvent;
	dataRendered?: DataRenderedEvent;
	headerRendering?: HeaderRenderingEvent;
	headerRendered?: HeaderRenderedEvent;
	footerRendering?: FooterRenderingEvent;
	footerRendered?: FooterRenderedEvent;
	headerCellRendered?: HeaderCellRenderedEvent;
	rowsRendering?: RowsRenderingEvent;
	rowsRendered?: RowsRenderedEvent;
	schemaGenerated?: SchemaGeneratedEvent;
	columnsCollectionModified?: ColumnsCollectionModifiedEvent;
	requestError?: RequestErrorEvent;
	created?: CreatedEvent;
	destroyed?: DestroyedEvent;
}
interface IgGridMethods {
	widget(): void;
	hasFixedDataSkippedColumns(): boolean;
	hasFixedColumns(): boolean;
	fixingDirection(): void;
	isFixedColumn(colKey: Object): boolean;
	resizeContainer(): void;
	id(): string;
	container(): Element;
	headersTable(): Element;
	footersTable(): Element;
	scrollContainer(): Element;
	fixedContainer(): Element;
	fixedBodyContainer(): Element;
	fixedFooterContainer(): Object;
	fixedHeaderContainer(): Object;
	fixedHeadersTable(): Element;
	fixedFootersTable(): Element;
	cellAt(x: number, y: number, isFixed: boolean): Element;
	cellById(rowId: Object, columnKey: string): Element;
	fixedTable(): Object;
	immediateChildrenWidgets(): any[];
	childrenWidgets(): any[];
	children(): any[];
	immediateChildren(): any[];
	rowAt(i: number): Element;
	rowById(rowId: Object, isFixed?: boolean): Element;
	fixedRowAt(i: number): Element;
	fixedRows(): any[];
	rows(): any[];
	allFixedRows(): any[];
	allRows(): any[];
	columnByKey(key: string): Object;
	columnByText(text: string): Object;
	selectedCells(): any[];
	selectedRows(): any[];
	selectedCell(): Object;
	selectedRow(): Object;
	activeCell(): Object;
	activeRow(): Object;
	getCellValue(rowId: Object, colKey: string): Object;
	getCellText(rowId: Object, colKey: string): string;
	setColumnTemplate(col: Object, tmpl: string, render?: boolean): void;
	commit(rowId?: Object): void;
	rollback(rowId?: Object, updateUI?: boolean): void;
	findRecordByKey(key: string): Object;
	getDetachedRecord(t: Object): Object;
	pendingTransactions(): any[];
	allTransactions(): any[];
	transactionsAsString(): string;
	saveChanges(success: Function, error: Function): void;
	renderNewRow(rec?: string): void;
	dataSourceObject(dataSource: Object): void;
	totalRecordsCount(): number;
	dataBind(internal: Object): void;
	moveColumn(column: Object, target: Object, after?: boolean, inDom?: boolean, callback?: Function): void;
	showColumn(column: Object, callback: Function): void;
	hideColumn(column: Object, callback: Function): void;
	getUnboundValues(key: string): Object;
	setUnboundValues(key: string, values: any[], removeOldValues: Object): void;
	setUnboundValueByPK(col: Object, rowId: Object, val: Object, notToRender: Object): void;
	getUnboundColumnByKey(key: string): Object;
	hasVerticalScrollbar(): Object;
	autoSizeColumns(): void;
	calculateAutoFitColumnWidth(columnIndex: number): number;
	getVisibleIndexByKey(columnKey: string, includeDataSkip: boolean): number;
	renderMultiColumnHeader(cols: any[]): void;
	virtualScrollTo(scrollerPosition: Object): void;
	destroy(notToCallDestroy: Object): void;
}
interface JQuery {
	data(propertyName: "igGrid"):IgGridMethods;
}

interface JQuery {
	igGrid(methodName: "widget"): void;
	igGrid(methodName: "hasFixedDataSkippedColumns"): boolean;
	igGrid(methodName: "hasFixedColumns"): boolean;
	igGrid(methodName: "fixingDirection"): void;
	igGrid(methodName: "isFixedColumn", colKey: Object): boolean;
	igGrid(methodName: "resizeContainer"): void;
	igGrid(methodName: "id"): string;
	igGrid(methodName: "container"): Element;
	igGrid(methodName: "headersTable"): Element;
	igGrid(methodName: "footersTable"): Element;
	igGrid(methodName: "scrollContainer"): Element;
	igGrid(methodName: "fixedContainer"): Element;
	igGrid(methodName: "fixedBodyContainer"): Element;
	igGrid(methodName: "fixedFooterContainer"): Object;
	igGrid(methodName: "fixedHeaderContainer"): Object;
	igGrid(methodName: "fixedHeadersTable"): Element;
	igGrid(methodName: "fixedFootersTable"): Element;
	igGrid(methodName: "cellAt", x: number, y: number, isFixed: boolean): Element;
	igGrid(methodName: "cellById", rowId: Object, columnKey: string): Element;
	igGrid(methodName: "fixedTable"): Object;
	igGrid(methodName: "immediateChildrenWidgets"): any[];
	igGrid(methodName: "childrenWidgets"): any[];
	igGrid(methodName: "children"): any[];
	igGrid(methodName: "immediateChildren"): any[];
	igGrid(methodName: "rowAt", i: number): Element;
	igGrid(methodName: "rowById", rowId: Object, isFixed?: boolean): Element;
	igGrid(methodName: "fixedRowAt", i: number): Element;
	igGrid(methodName: "fixedRows"): any[];
	igGrid(methodName: "rows"): any[];
	igGrid(methodName: "allFixedRows"): any[];
	igGrid(methodName: "allRows"): any[];
	igGrid(methodName: "columnByKey", key: string): Object;
	igGrid(methodName: "columnByText", text: string): Object;
	igGrid(methodName: "selectedCells"): any[];
	igGrid(methodName: "selectedRows"): any[];
	igGrid(methodName: "selectedCell"): Object;
	igGrid(methodName: "selectedRow"): Object;
	igGrid(methodName: "activeCell"): Object;
	igGrid(methodName: "activeRow"): Object;
	igGrid(methodName: "getCellValue", rowId: Object, colKey: string): Object;
	igGrid(methodName: "getCellText", rowId: Object, colKey: string): string;
	igGrid(methodName: "setColumnTemplate", col: Object, tmpl: string, render?: boolean): void;
	igGrid(methodName: "commit", rowId?: Object): void;
	igGrid(methodName: "rollback", rowId?: Object, updateUI?: boolean): void;
	igGrid(methodName: "findRecordByKey", key: string): Object;
	igGrid(methodName: "getDetachedRecord", t: Object): Object;
	igGrid(methodName: "pendingTransactions"): any[];
	igGrid(methodName: "allTransactions"): any[];
	igGrid(methodName: "transactionsAsString"): string;
	igGrid(methodName: "saveChanges", success: Function, error: Function): void;
	igGrid(methodName: "renderNewRow", rec?: string): void;
	igGrid(methodName: "dataSourceObject", dataSource: Object): void;
	igGrid(methodName: "totalRecordsCount"): number;
	igGrid(methodName: "dataBind", internal: Object): void;
	igGrid(methodName: "moveColumn", column: Object, target: Object, after?: boolean, inDom?: boolean, callback?: Function): void;
	igGrid(methodName: "showColumn", column: Object, callback: Function): void;
	igGrid(methodName: "hideColumn", column: Object, callback: Function): void;
	igGrid(methodName: "getUnboundValues", key: string): Object;
	igGrid(methodName: "setUnboundValues", key: string, values: any[], removeOldValues: Object): void;
	igGrid(methodName: "setUnboundValueByPK", col: Object, rowId: Object, val: Object, notToRender: Object): void;
	igGrid(methodName: "getUnboundColumnByKey", key: string): Object;
	igGrid(methodName: "hasVerticalScrollbar"): Object;
	igGrid(methodName: "autoSizeColumns"): void;
	igGrid(methodName: "calculateAutoFitColumnWidth", columnIndex: number): number;
	igGrid(methodName: "getVisibleIndexByKey", columnKey: string, includeDataSkip: boolean): number;
	igGrid(methodName: "renderMultiColumnHeader", cols: any[]): void;
	igGrid(methodName: "virtualScrollTo", scrollerPosition: Object): void;
	igGrid(methodName: "destroy", notToCallDestroy: Object): void;
	igGrid(optionLiteral: 'option', optionName: "width"): any;
	igGrid(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igGrid(optionLiteral: 'option', optionName: "height"): any;
	igGrid(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igGrid(optionLiteral: 'option', optionName: "autoAdjustHeight"): boolean;
	igGrid(optionLiteral: 'option', optionName: "autoAdjustHeight", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "avgRowHeight"): any;
	igGrid(optionLiteral: 'option', optionName: "avgRowHeight", optionValue: any): void;
	igGrid(optionLiteral: 'option', optionName: "avgColumnWidth"): any;
	igGrid(optionLiteral: 'option', optionName: "avgColumnWidth", optionValue: any): void;
	igGrid(optionLiteral: 'option', optionName: "defaultColumnWidth"): any;
	igGrid(optionLiteral: 'option', optionName: "defaultColumnWidth", optionValue: any): void;
	igGrid(optionLiteral: 'option', optionName: "autoGenerateColumns"): boolean;
	igGrid(optionLiteral: 'option', optionName: "autoGenerateColumns", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "virtualization"): boolean;
	igGrid(optionLiteral: 'option', optionName: "virtualization", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "virtualizationMode"): any;
	igGrid(optionLiteral: 'option', optionName: "virtualizationMode", optionValue: any): void;
	igGrid(optionLiteral: 'option', optionName: "requiresDataBinding"): boolean;
	igGrid(optionLiteral: 'option', optionName: "requiresDataBinding", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "rowVirtualization"): boolean;
	igGrid(optionLiteral: 'option', optionName: "rowVirtualization", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "columnVirtualization"): boolean;
	igGrid(optionLiteral: 'option', optionName: "columnVirtualization", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "virtualizationMouseWheelStep"): number;
	igGrid(optionLiteral: 'option', optionName: "virtualizationMouseWheelStep", optionValue: number): void;
	igGrid(optionLiteral: 'option', optionName: "adjustVirtualHeights"): boolean;
	igGrid(optionLiteral: 'option', optionName: "adjustVirtualHeights", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "rowTemplate"): string;
	igGrid(optionLiteral: 'option', optionName: "rowTemplate", optionValue: string): void;
	igGrid(optionLiteral: 'option', optionName: "jQueryTemplating"): boolean;
	igGrid(optionLiteral: 'option', optionName: "jQueryTemplating", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "templatingEngine"): any;
	igGrid(optionLiteral: 'option', optionName: "templatingEngine", optionValue: any): void;
	igGrid(optionLiteral: 'option', optionName: "columns"): IgGridColumn[];
	igGrid(optionLiteral: 'option', optionName: "columns", optionValue: IgGridColumn[]): void;
	igGrid(optionLiteral: 'option', optionName: "dataSource"): any;
	igGrid(optionLiteral: 'option', optionName: "dataSource", optionValue: any): void;
	igGrid(optionLiteral: 'option', optionName: "dataSourceUrl"): string;
	igGrid(optionLiteral: 'option', optionName: "dataSourceUrl", optionValue: string): void;
	igGrid(optionLiteral: 'option', optionName: "dataSourceType"): string;
	igGrid(optionLiteral: 'option', optionName: "dataSourceType", optionValue: string): void;
	igGrid(optionLiteral: 'option', optionName: "responseDataKey"): string;
	igGrid(optionLiteral: 'option', optionName: "responseDataKey", optionValue: string): void;
	igGrid(optionLiteral: 'option', optionName: "responseTotalRecCountKey"): string;
	igGrid(optionLiteral: 'option', optionName: "responseTotalRecCountKey", optionValue: string): void;
	igGrid(optionLiteral: 'option', optionName: "requestType"): string;
	igGrid(optionLiteral: 'option', optionName: "requestType", optionValue: string): void;
	igGrid(optionLiteral: 'option', optionName: "responseContentType"): string;
	igGrid(optionLiteral: 'option', optionName: "responseContentType", optionValue: string): void;
	igGrid(optionLiteral: 'option', optionName: "showHeader"): boolean;
	igGrid(optionLiteral: 'option', optionName: "showHeader", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "showFooter"): boolean;
	igGrid(optionLiteral: 'option', optionName: "showFooter", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "fixedHeaders"): boolean;
	igGrid(optionLiteral: 'option', optionName: "fixedHeaders", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "fixedFooters"): boolean;
	igGrid(optionLiteral: 'option', optionName: "fixedFooters", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "caption"): string;
	igGrid(optionLiteral: 'option', optionName: "caption", optionValue: string): void;
	igGrid(optionLiteral: 'option', optionName: "features"): IgGridFeatures;
	igGrid(optionLiteral: 'option', optionName: "features", optionValue: IgGridFeatures): void;
	igGrid(optionLiteral: 'option', optionName: "tabIndex"): number;
	igGrid(optionLiteral: 'option', optionName: "tabIndex", optionValue: number): void;
	igGrid(optionLiteral: 'option', optionName: "accessibilityRendering"): boolean;
	igGrid(optionLiteral: 'option', optionName: "accessibilityRendering", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "localSchemaTransform"): boolean;
	igGrid(optionLiteral: 'option', optionName: "localSchemaTransform", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "primaryKey"): string;
	igGrid(optionLiteral: 'option', optionName: "primaryKey", optionValue: string): void;
	igGrid(optionLiteral: 'option', optionName: "serializeTransactionLog"): boolean;
	igGrid(optionLiteral: 'option', optionName: "serializeTransactionLog", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "autoCommit"): boolean;
	igGrid(optionLiteral: 'option', optionName: "autoCommit", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "aggregateTransactions"): boolean;
	igGrid(optionLiteral: 'option', optionName: "aggregateTransactions", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "autoFormat"): any;
	igGrid(optionLiteral: 'option', optionName: "autoFormat", optionValue: any): void;
	igGrid(optionLiteral: 'option', optionName: "renderCheckboxes"): boolean;
	igGrid(optionLiteral: 'option', optionName: "renderCheckboxes", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "updateUrl"): string;
	igGrid(optionLiteral: 'option', optionName: "updateUrl", optionValue: string): void;
	igGrid(optionLiteral: 'option', optionName: "restSettings"): IgGridRestSettings;
	igGrid(optionLiteral: 'option', optionName: "restSettings", optionValue: IgGridRestSettings): void;
	igGrid(optionLiteral: 'option', optionName: "alternateRowStyles"): boolean;
	igGrid(optionLiteral: 'option', optionName: "alternateRowStyles", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "autofitLastColumn"): boolean;
	igGrid(optionLiteral: 'option', optionName: "autofitLastColumn", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "enableHoverStyles"): boolean;
	igGrid(optionLiteral: 'option', optionName: "enableHoverStyles", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "enableUTCDates"): boolean;
	igGrid(optionLiteral: 'option', optionName: "enableUTCDates", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "mergeUnboundColumns"): boolean;
	igGrid(optionLiteral: 'option', optionName: "mergeUnboundColumns", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "jsonpRequest"): boolean;
	igGrid(optionLiteral: 'option', optionName: "jsonpRequest", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "enableResizeContainerCheck"): boolean;
	igGrid(optionLiteral: 'option', optionName: "enableResizeContainerCheck", optionValue: boolean): void;
	igGrid(optionLiteral: 'option', optionName: "featureChooserIconDisplay"): any;
	igGrid(optionLiteral: 'option', optionName: "featureChooserIconDisplay", optionValue: any): void;
	igGrid(optionLiteral: 'option', optionName: "cellClick"): CellClickEvent;
	igGrid(optionLiteral: 'option', optionName: "cellClick", optionValue: CellClickEvent): void;
	igGrid(optionLiteral: 'option', optionName: "cellRightClick"): CellRightClickEvent;
	igGrid(optionLiteral: 'option', optionName: "cellRightClick", optionValue: CellRightClickEvent): void;
	igGrid(optionLiteral: 'option', optionName: "dataBinding"): DataBindingEvent;
	igGrid(optionLiteral: 'option', optionName: "dataBinding", optionValue: DataBindingEvent): void;
	igGrid(optionLiteral: 'option', optionName: "dataBound"): DataBoundEvent;
	igGrid(optionLiteral: 'option', optionName: "dataBound", optionValue: DataBoundEvent): void;
	igGrid(optionLiteral: 'option', optionName: "rendering"): RenderingEvent;
	igGrid(optionLiteral: 'option', optionName: "rendering", optionValue: RenderingEvent): void;
	igGrid(optionLiteral: 'option', optionName: "rendered"): RenderedEvent;
	igGrid(optionLiteral: 'option', optionName: "rendered", optionValue: RenderedEvent): void;
	igGrid(optionLiteral: 'option', optionName: "dataRendering"): DataRenderingEvent;
	igGrid(optionLiteral: 'option', optionName: "dataRendering", optionValue: DataRenderingEvent): void;
	igGrid(optionLiteral: 'option', optionName: "dataRendered"): DataRenderedEvent;
	igGrid(optionLiteral: 'option', optionName: "dataRendered", optionValue: DataRenderedEvent): void;
	igGrid(optionLiteral: 'option', optionName: "headerRendering"): HeaderRenderingEvent;
	igGrid(optionLiteral: 'option', optionName: "headerRendering", optionValue: HeaderRenderingEvent): void;
	igGrid(optionLiteral: 'option', optionName: "headerRendered"): HeaderRenderedEvent;
	igGrid(optionLiteral: 'option', optionName: "headerRendered", optionValue: HeaderRenderedEvent): void;
	igGrid(optionLiteral: 'option', optionName: "footerRendering"): FooterRenderingEvent;
	igGrid(optionLiteral: 'option', optionName: "footerRendering", optionValue: FooterRenderingEvent): void;
	igGrid(optionLiteral: 'option', optionName: "footerRendered"): FooterRenderedEvent;
	igGrid(optionLiteral: 'option', optionName: "footerRendered", optionValue: FooterRenderedEvent): void;
	igGrid(optionLiteral: 'option', optionName: "headerCellRendered"): HeaderCellRenderedEvent;
	igGrid(optionLiteral: 'option', optionName: "headerCellRendered", optionValue: HeaderCellRenderedEvent): void;
	igGrid(optionLiteral: 'option', optionName: "rowsRendering"): RowsRenderingEvent;
	igGrid(optionLiteral: 'option', optionName: "rowsRendering", optionValue: RowsRenderingEvent): void;
	igGrid(optionLiteral: 'option', optionName: "rowsRendered"): RowsRenderedEvent;
	igGrid(optionLiteral: 'option', optionName: "rowsRendered", optionValue: RowsRenderedEvent): void;
	igGrid(optionLiteral: 'option', optionName: "schemaGenerated"): SchemaGeneratedEvent;
	igGrid(optionLiteral: 'option', optionName: "schemaGenerated", optionValue: SchemaGeneratedEvent): void;
	igGrid(optionLiteral: 'option', optionName: "columnsCollectionModified"): ColumnsCollectionModifiedEvent;
	igGrid(optionLiteral: 'option', optionName: "columnsCollectionModified", optionValue: ColumnsCollectionModifiedEvent): void;
	igGrid(optionLiteral: 'option', optionName: "requestError"): RequestErrorEvent;
	igGrid(optionLiteral: 'option', optionName: "requestError", optionValue: RequestErrorEvent): void;
	igGrid(optionLiteral: 'option', optionName: "created"): CreatedEvent;
	igGrid(optionLiteral: 'option', optionName: "created", optionValue: CreatedEvent): void;
	igGrid(optionLiteral: 'option', optionName: "destroyed"): DestroyedEvent;
	igGrid(optionLiteral: 'option', optionName: "destroyed", optionValue: DestroyedEvent): void;
	igGrid(options: IgGrid): JQuery;
	igGrid(optionLiteral: 'option', optionName: string): any;
	igGrid(optionLiteral: 'option', options: IgGrid): JQuery;
	igGrid(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGrid(methodName: string, ...methodParams: any[]): any;
}
interface IgGridGroupByGroupedColumns {
	key?: string;
	dir?: any;
	layout?: string;
	col?: any;
}

interface IgGridGroupBySummarySettings {
	multiSummaryDelimiter?: string;
	summaryFormat?: string;
}

interface IgGridGroupByColumnSettingsSummaries {
	summaryFunction?: any;
	text?: any;
	customSummary?: any;
}

interface IgGridGroupByColumnSettings {
	allowGrouping?: boolean;
	isGroupBy?: boolean;
	groupComparerFunction?: Function;
	groupLabelFormatter?: Function;
	dir?: any;
	summaries?: IgGridGroupByColumnSettingsSummaries;
}

interface GroupedColumnsChangingEvent {
	(event: Event, ui: GroupedColumnsChangingEventUIParam): void;
}

interface GroupedColumnsChangingEventUIParam {
	owner?: any;
	groupedColumns?: any;
	newGroupedColumns?: any;
	key?: any;
	layout?: any;
	grid?: any;
	triggeredBy?: any;
}

interface GroupedColumnsChangedEvent {
	(event: Event, ui: GroupedColumnsChangedEventUIParam): void;
}

interface GroupedColumnsChangedEventUIParam {
	owner?: any;
	groupedColumns?: any;
	key?: any;
	layout?: any;
	grid?: any;
	triggeredBy?: any;
}

interface ModalDialogButtonApplyClickEvent {
	(event: Event, ui: ModalDialogButtonApplyClickEventUIParam): void;
}

interface ModalDialogButtonApplyClickEventUIParam {
	owner?: any;
	modalDialogElement?: any;
	groupedColumns?: any;
	groupedColumnLayouts?: any;
	sortingExpr?: any;
}

interface ModalDialogButtonResetClickEvent {
	(event: Event, ui: ModalDialogButtonResetClickEventUIParam): void;
}

interface ModalDialogButtonResetClickEventUIParam {
	owner?: any;
	modalDialogElement?: any;
}

interface ModalDialogGroupingColumnEvent {
	(event: Event, ui: ModalDialogGroupingColumnEventUIParam): void;
}

interface ModalDialogGroupingColumnEventUIParam {
	owner?: any;
	key?: any;
	layout?: any;
}

interface ModalDialogGroupColumnEvent {
	(event: Event, ui: ModalDialogGroupColumnEventUIParam): void;
}

interface ModalDialogGroupColumnEventUIParam {
	owner?: any;
	key?: any;
	groupedColumns?: any;
	layout?: any;
}

interface ModalDialogUngroupingColumnEvent {
	(event: Event, ui: ModalDialogUngroupingColumnEventUIParam): void;
}

interface ModalDialogUngroupingColumnEventUIParam {
	owner?: any;
	key?: any;
	layout?: any;
}

interface ModalDialogUngroupColumnEvent {
	(event: Event, ui: ModalDialogUngroupColumnEventUIParam): void;
}

interface ModalDialogUngroupColumnEventUIParam {
	owner?: any;
	groupedColumns?: any;
	key?: any;
	layout?: any;
}

interface ModalDialogSortGroupedColumnEvent {
	(event: Event, ui: ModalDialogSortGroupedColumnEventUIParam): void;
}

interface ModalDialogSortGroupedColumnEventUIParam {
	owner?: any;
	key?: any;
	layout?: any;
	isAsc?: any;
}

interface IgGridGroupBy {
	groupByAreaVisibility?: any;
	initialExpand?: boolean;
	emptyGroupByAreaContent?: string;
	emptyGroupByAreaContentSelectColumns?: string;
	expansionIndicatorVisibility?: boolean;
	groupByLabelWidth?: number;
	labelDragHelperOpacity?: number;
	indentation?: number;
	defaultSortingDirection?: any;
	groupedColumns?: IgGridGroupByGroupedColumns;
	resultResponseKey?: string;
	groupedRowTextTemplate?: string;
	type?: any;
	groupByUrlKey?: string;
	groupByUrlKeyAscValue?: string;
	groupByUrlKeyDescValue?: string;
	summarySettings?: IgGridGroupBySummarySettings;
	columnSettings?: IgGridGroupByColumnSettings;
	expandTooltip?: string;
	collapseTooltip?: string;
	removeButtonTooltip?: string;
	featureChooserText?: string;
	featureChooserTextHide?: string;
	modalDialogGroupByOnClick?: boolean;
	modalDialogGroupByButtonText?: string;
	modalDialogCaptionButtonDesc?: string;
	modalDialogCaptionButtonAsc?: string;
	modalDialogCaptionButtonUngroup?: string;
	modalDialogCaptionText?: string;
	modalDialogDropDownLabel?: string;
	modalDialogRootLevelHierarchicalGrid?: string;
	modalDialogDropDownButtonCaption?: string;
	modalDialogClearAllButtonLabel?: string;
	emptyGroupByAreaContentSelectColumnsCaption?: string;
	modalDialogDropDownWidth?: number;
	modalDialogDropDownAreaWidth?: number;
	modalDialogAnimationDuration?: number;
	modalDialogWidth?: number;
	modalDialogHeight?: number;
	modalDialogButtonApplyText?: string;
	modalDialogButtonCancelText?: string;
	useGridColumnFormatter?: boolean;
	persist?: boolean;
	groupByDialogContainment?: string;
	inherit?: boolean;
	groupedColumnsChanging?: GroupedColumnsChangingEvent;
	groupedColumnsChanged?: GroupedColumnsChangedEvent;
	modalDialogMoving?: ModalDialogMovingEvent;
	modalDialogClosing?: ModalDialogClosingEvent;
	modalDialogClosed?: ModalDialogClosedEvent;
	modalDialogOpening?: ModalDialogOpeningEvent;
	modalDialogOpened?: ModalDialogOpenedEvent;
	modalDialogContentsRendering?: ModalDialogContentsRenderingEvent;
	modalDialogContentsRendered?: ModalDialogContentsRenderedEvent;
	modalDialogButtonApplyClick?: ModalDialogButtonApplyClickEvent;
	modalDialogButtonResetClick?: ModalDialogButtonResetClickEvent;
	modalDialogGroupingColumn?: ModalDialogGroupingColumnEvent;
	modalDialogGroupColumn?: ModalDialogGroupColumnEvent;
	modalDialogUngroupingColumn?: ModalDialogUngroupingColumnEvent;
	modalDialogUngroupColumn?: ModalDialogUngroupColumnEvent;
	modalDialogSortGroupedColumn?: ModalDialogSortGroupedColumnEvent;
}
interface IgGridGroupByMethods {
	openGroupByDialog(): void;
	closeGroupByDialog(): void;
	renderGroupByModalDialog(): void;
	openDropDown(): void;
	closeDropDown(): void;
	checkColumnIsGrouped(key: string, layout: string): void;
	getGroupedData(data: any[], colKey: string, idval: Object, setting: Object): any[];
	groupByColumns(): Object;
	groupByColumn(key: string, layout?: string, sortingDirection?: Object): void;
	ungroupByColumn(key: string, layout?: string): void;
	ungroupAll(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igGridGroupBy"):IgGridGroupByMethods;
}

interface JQuery {
	igGridGroupBy(methodName: "openGroupByDialog"): void;
	igGridGroupBy(methodName: "closeGroupByDialog"): void;
	igGridGroupBy(methodName: "renderGroupByModalDialog"): void;
	igGridGroupBy(methodName: "openDropDown"): void;
	igGridGroupBy(methodName: "closeDropDown"): void;
	igGridGroupBy(methodName: "checkColumnIsGrouped", key: string, layout: string): void;
	igGridGroupBy(methodName: "getGroupedData", data: any[], colKey: string, idval: Object, setting: Object): any[];
	igGridGroupBy(methodName: "groupByColumns"): Object;
	igGridGroupBy(methodName: "groupByColumn", key: string, layout?: string, sortingDirection?: Object): void;
	igGridGroupBy(methodName: "ungroupByColumn", key: string, layout?: string): void;
	igGridGroupBy(methodName: "ungroupAll"): void;
	igGridGroupBy(methodName: "destroy"): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByAreaVisibility"): any;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByAreaVisibility", optionValue: any): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "initialExpand"): boolean;
	igGridGroupBy(optionLiteral: 'option', optionName: "initialExpand", optionValue: boolean): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "emptyGroupByAreaContent"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "emptyGroupByAreaContent", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "emptyGroupByAreaContentSelectColumns"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "emptyGroupByAreaContentSelectColumns", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "expansionIndicatorVisibility"): boolean;
	igGridGroupBy(optionLiteral: 'option', optionName: "expansionIndicatorVisibility", optionValue: boolean): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByLabelWidth"): number;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByLabelWidth", optionValue: number): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "labelDragHelperOpacity"): number;
	igGridGroupBy(optionLiteral: 'option', optionName: "labelDragHelperOpacity", optionValue: number): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "indentation"): number;
	igGridGroupBy(optionLiteral: 'option', optionName: "indentation", optionValue: number): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "defaultSortingDirection"): any;
	igGridGroupBy(optionLiteral: 'option', optionName: "defaultSortingDirection", optionValue: any): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupedColumns"): IgGridGroupByGroupedColumns;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupedColumns", optionValue: IgGridGroupByGroupedColumns): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "resultResponseKey"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "resultResponseKey", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupedRowTextTemplate"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupedRowTextTemplate", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "type"): any;
	igGridGroupBy(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByUrlKey"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByUrlKey", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByUrlKeyAscValue"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByUrlKeyAscValue", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByUrlKeyDescValue"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByUrlKeyDescValue", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "summarySettings"): IgGridGroupBySummarySettings;
	igGridGroupBy(optionLiteral: 'option', optionName: "summarySettings", optionValue: IgGridGroupBySummarySettings): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "columnSettings"): IgGridGroupByColumnSettings;
	igGridGroupBy(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridGroupByColumnSettings): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "expandTooltip"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "expandTooltip", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "collapseTooltip"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "collapseTooltip", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "removeButtonTooltip"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "removeButtonTooltip", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "featureChooserText"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "featureChooserText", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "featureChooserTextHide"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "featureChooserTextHide", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogGroupByOnClick"): boolean;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogGroupByOnClick", optionValue: boolean): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogGroupByButtonText"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogGroupByButtonText", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogCaptionButtonDesc"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogCaptionButtonDesc", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogCaptionButtonAsc"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogCaptionButtonAsc", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogCaptionButtonUngroup"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogCaptionButtonUngroup", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogCaptionText"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogCaptionText", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogDropDownLabel"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogDropDownLabel", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogRootLevelHierarchicalGrid"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogRootLevelHierarchicalGrid", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogDropDownButtonCaption"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogDropDownButtonCaption", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogClearAllButtonLabel"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogClearAllButtonLabel", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "emptyGroupByAreaContentSelectColumnsCaption"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "emptyGroupByAreaContentSelectColumnsCaption", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogDropDownWidth"): number;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogDropDownWidth", optionValue: number): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogDropDownAreaWidth"): number;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogDropDownAreaWidth", optionValue: number): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogAnimationDuration"): number;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogAnimationDuration", optionValue: number): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogWidth"): number;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogWidth", optionValue: number): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogHeight"): number;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogHeight", optionValue: number): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogButtonApplyText"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogButtonApplyText", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogButtonCancelText"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogButtonCancelText", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "useGridColumnFormatter"): boolean;
	igGridGroupBy(optionLiteral: 'option', optionName: "useGridColumnFormatter", optionValue: boolean): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "persist"): boolean;
	igGridGroupBy(optionLiteral: 'option', optionName: "persist", optionValue: boolean): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByDialogContainment"): string;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupByDialogContainment", optionValue: string): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridGroupBy(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupedColumnsChanging"): GroupedColumnsChangingEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupedColumnsChanging", optionValue: GroupedColumnsChangingEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupedColumnsChanged"): GroupedColumnsChangedEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "groupedColumnsChanged", optionValue: GroupedColumnsChangedEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogMoving"): ModalDialogMovingEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogMoving", optionValue: ModalDialogMovingEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogClosing"): ModalDialogClosingEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogClosing", optionValue: ModalDialogClosingEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogClosed"): ModalDialogClosedEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogClosed", optionValue: ModalDialogClosedEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogOpening"): ModalDialogOpeningEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogOpening", optionValue: ModalDialogOpeningEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogOpened"): ModalDialogOpenedEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogOpened", optionValue: ModalDialogOpenedEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogContentsRendering"): ModalDialogContentsRenderingEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogContentsRendering", optionValue: ModalDialogContentsRenderingEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogContentsRendered"): ModalDialogContentsRenderedEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogContentsRendered", optionValue: ModalDialogContentsRenderedEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogButtonApplyClick"): ModalDialogButtonApplyClickEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogButtonApplyClick", optionValue: ModalDialogButtonApplyClickEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogButtonResetClick"): ModalDialogButtonResetClickEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogButtonResetClick", optionValue: ModalDialogButtonResetClickEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogGroupingColumn"): ModalDialogGroupingColumnEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogGroupingColumn", optionValue: ModalDialogGroupingColumnEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogGroupColumn"): ModalDialogGroupColumnEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogGroupColumn", optionValue: ModalDialogGroupColumnEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogUngroupingColumn"): ModalDialogUngroupingColumnEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogUngroupingColumn", optionValue: ModalDialogUngroupingColumnEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogUngroupColumn"): ModalDialogUngroupColumnEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogUngroupColumn", optionValue: ModalDialogUngroupColumnEvent): void;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogSortGroupedColumn"): ModalDialogSortGroupedColumnEvent;
	igGridGroupBy(optionLiteral: 'option', optionName: "modalDialogSortGroupedColumn", optionValue: ModalDialogSortGroupedColumnEvent): void;
	igGridGroupBy(options: IgGridGroupBy): JQuery;
	igGridGroupBy(optionLiteral: 'option', optionName: string): any;
	igGridGroupBy(optionLiteral: 'option', options: IgGridGroupBy): JQuery;
	igGridGroupBy(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridGroupBy(methodName: string, ...methodParams: any[]): any;
}
interface IgGridHidingColumnSetting {
	columnKey?: string;
	columnIndex?: number;
	allowHiding?: boolean;
	hidden?: boolean;
}

interface ColumnHidingEvent {
	(event: Event, ui: ColumnHidingEventUIParam): void;
}

interface ColumnHidingEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
}

interface ColumnHidingRefusedEvent {
	(event: Event, ui: ColumnHidingRefusedEventUIParam): void;
}

interface ColumnHidingRefusedEventUIParam {
	owner?: any;
	columnKeys?: any;
}

interface ColumnShowingRefusedEvent {
	(event: Event, ui: ColumnShowingRefusedEventUIParam): void;
}

interface ColumnShowingRefusedEventUIParam {
	owner?: any;
	columnKeys?: any;
}

interface MultiColumnHidingEvent {
	(event: Event, ui: MultiColumnHidingEventUIParam): void;
}

interface MultiColumnHidingEventUIParam {
	owner?: any;
	columnKeys?: any;
}

interface ColumnHiddenEvent {
	(event: Event, ui: ColumnHiddenEventUIParam): void;
}

interface ColumnHiddenEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
}

interface ColumnShowingEvent {
	(event: Event, ui: ColumnShowingEventUIParam): void;
}

interface ColumnShowingEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
}

interface ColumnShownEvent {
	(event: Event, ui: ColumnShownEventUIParam): void;
}

interface ColumnShownEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
}

interface ColumnChooserOpeningEvent {
	(event: Event, ui: ColumnChooserOpeningEventUIParam): void;
}

interface ColumnChooserOpeningEventUIParam {
	owner?: any;
	columnChooserElement?: any;
}

interface ColumnChooserOpenedEvent {
	(event: Event, ui: ColumnChooserOpenedEventUIParam): void;
}

interface ColumnChooserOpenedEventUIParam {
	owner?: any;
	columnChooserElement?: any;
}

interface ColumnChooserMovingEvent {
	(event: Event, ui: ColumnChooserMovingEventUIParam): void;
}

interface ColumnChooserMovingEventUIParam {
	owner?: any;
	columnChooserElement?: any;
	originalPosition?: any;
	position?: any;
}

interface ColumnChooserClosingEvent {
	(event: Event, ui: ColumnChooserClosingEventUIParam): void;
}

interface ColumnChooserClosingEventUIParam {
	owner?: any;
	columnChooserElement?: any;
}

interface ColumnChooserClosedEvent {
	(event: Event, ui: ColumnChooserClosedEventUIParam): void;
}

interface ColumnChooserClosedEventUIParam {
	owner?: any;
	columnChooserElement?: any;
}

interface ColumnChooserContentsRenderingEvent {
	(event: Event, ui: ColumnChooserContentsRenderingEventUIParam): void;
}

interface ColumnChooserContentsRenderingEventUIParam {
	owner?: any;
	columnChooserElement?: any;
}

interface ColumnChooserContentsRenderedEvent {
	(event: Event, ui: ColumnChooserContentsRenderedEventUIParam): void;
}

interface ColumnChooserContentsRenderedEventUIParam {
	owner?: any;
	columnChooserElement?: any;
}

interface ColumnChooserButtonApplyClickEvent {
	(event: Event, ui: ColumnChooserButtonApplyClickEventUIParam): void;
}

interface ColumnChooserButtonApplyClickEventUIParam {
	owner?: any;
	columnChooserElement?: any;
	columnsToShow?: any;
	columnsToHide?: any;
}

interface ColumnChooserButtonResetClickEvent {
	(event: Event, ui: ColumnChooserButtonResetClickEventUIParam): void;
}

interface ColumnChooserButtonResetClickEventUIParam {
	owner?: any;
	columnChooserElement?: any;
}

interface IgGridHiding {
	columnSettings?: IgGridHidingColumnSetting[];
	hiddenColumnIndicatorHeaderWidth?: number;
	columnChooserContainment?: string;
	columnChooserWidth?: number;
	columnChooserHeight?: number;
	dropDownAnimationDuration?: number;
	columnChooserCaptionText?: string;
	columnChooserDisplayText?: string;
	hiddenColumnIndicatorTooltipText?: string;
	columnHideText?: string;
	columnChooserShowText?: string;
	columnChooserHideText?: string;
	columnChooserHideOnClick?: boolean;
	columnChooserResetButtonLabel?: string;
	columnChooserAnimationDuration?: number;
	columnChooserButtonApplyText?: string;
	columnChooserButtonCancelText?: string;
	inherit?: boolean;
	columnHiding?: ColumnHidingEvent;
	columnHidingRefused?: ColumnHidingRefusedEvent;
	columnShowingRefused?: ColumnShowingRefusedEvent;
	multiColumnHiding?: MultiColumnHidingEvent;
	columnHidden?: ColumnHiddenEvent;
	columnShowing?: ColumnShowingEvent;
	columnShown?: ColumnShownEvent;
	columnChooserOpening?: ColumnChooserOpeningEvent;
	columnChooserOpened?: ColumnChooserOpenedEvent;
	columnChooserMoving?: ColumnChooserMovingEvent;
	columnChooserClosing?: ColumnChooserClosingEvent;
	columnChooserClosed?: ColumnChooserClosedEvent;
	columnChooserContentsRendering?: ColumnChooserContentsRenderingEvent;
	columnChooserContentsRendered?: ColumnChooserContentsRenderedEvent;
	columnChooserButtonApplyClick?: ColumnChooserButtonApplyClickEvent;
	columnChooserButtonResetClick?: ColumnChooserButtonResetClickEvent;
}
interface IgGridHidingMethods {
	destroy(): void;
	showColumnChooser(): void;
	hideColumnChooser(): void;
	showColumn(column: Object, isMultiColumnHeader?: boolean, callback?: Function): void;
	hideColumn(column: Object, isMultiColumnHeader?: boolean, callback?: Function): void;
	hideMultiColumns(columns: any[], callback?: Function): void;
	showMultiColumns(columns: any[], callback?: Function): void;
	isToRenderButtonReset(): void;
	resetHidingColumnChooser(): void;
	renderColumnChooserResetButton(): void;
	removeColumnChooserResetButton(): void;
}
interface JQuery {
	data(propertyName: "igGridHiding"):IgGridHidingMethods;
}

interface JQuery {
	igGridHiding(methodName: "destroy"): void;
	igGridHiding(methodName: "showColumnChooser"): void;
	igGridHiding(methodName: "hideColumnChooser"): void;
	igGridHiding(methodName: "showColumn", column: Object, isMultiColumnHeader?: boolean, callback?: Function): void;
	igGridHiding(methodName: "hideColumn", column: Object, isMultiColumnHeader?: boolean, callback?: Function): void;
	igGridHiding(methodName: "hideMultiColumns", columns: any[], callback?: Function): void;
	igGridHiding(methodName: "showMultiColumns", columns: any[], callback?: Function): void;
	igGridHiding(methodName: "isToRenderButtonReset"): void;
	igGridHiding(methodName: "resetHidingColumnChooser"): void;
	igGridHiding(methodName: "renderColumnChooserResetButton"): void;
	igGridHiding(methodName: "removeColumnChooserResetButton"): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnSettings"): IgGridHidingColumnSetting[];
	igGridHiding(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridHidingColumnSetting[]): void;
	igGridHiding(optionLiteral: 'option', optionName: "hiddenColumnIndicatorHeaderWidth"): number;
	igGridHiding(optionLiteral: 'option', optionName: "hiddenColumnIndicatorHeaderWidth", optionValue: number): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserContainment"): string;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserContainment", optionValue: string): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserWidth"): number;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserWidth", optionValue: number): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserHeight"): number;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserHeight", optionValue: number): void;
	igGridHiding(optionLiteral: 'option', optionName: "dropDownAnimationDuration"): number;
	igGridHiding(optionLiteral: 'option', optionName: "dropDownAnimationDuration", optionValue: number): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserCaptionText"): string;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserCaptionText", optionValue: string): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserDisplayText"): string;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserDisplayText", optionValue: string): void;
	igGridHiding(optionLiteral: 'option', optionName: "hiddenColumnIndicatorTooltipText"): string;
	igGridHiding(optionLiteral: 'option', optionName: "hiddenColumnIndicatorTooltipText", optionValue: string): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnHideText"): string;
	igGridHiding(optionLiteral: 'option', optionName: "columnHideText", optionValue: string): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserShowText"): string;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserShowText", optionValue: string): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserHideText"): string;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserHideText", optionValue: string): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserHideOnClick"): boolean;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserHideOnClick", optionValue: boolean): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserResetButtonLabel"): string;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserResetButtonLabel", optionValue: string): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserAnimationDuration"): number;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserAnimationDuration", optionValue: number): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonApplyText"): string;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonApplyText", optionValue: string): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonCancelText"): string;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonCancelText", optionValue: string): void;
	igGridHiding(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridHiding(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnHiding"): ColumnHidingEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnHiding", optionValue: ColumnHidingEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnHidingRefused"): ColumnHidingRefusedEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnHidingRefused", optionValue: ColumnHidingRefusedEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnShowingRefused"): ColumnShowingRefusedEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnShowingRefused", optionValue: ColumnShowingRefusedEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "multiColumnHiding"): MultiColumnHidingEvent;
	igGridHiding(optionLiteral: 'option', optionName: "multiColumnHiding", optionValue: MultiColumnHidingEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnHidden"): ColumnHiddenEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnHidden", optionValue: ColumnHiddenEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnShowing"): ColumnShowingEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnShowing", optionValue: ColumnShowingEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnShown"): ColumnShownEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnShown", optionValue: ColumnShownEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserOpening"): ColumnChooserOpeningEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserOpening", optionValue: ColumnChooserOpeningEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserOpened"): ColumnChooserOpenedEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserOpened", optionValue: ColumnChooserOpenedEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserMoving"): ColumnChooserMovingEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserMoving", optionValue: ColumnChooserMovingEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserClosing"): ColumnChooserClosingEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserClosing", optionValue: ColumnChooserClosingEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserClosed"): ColumnChooserClosedEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserClosed", optionValue: ColumnChooserClosedEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserContentsRendering"): ColumnChooserContentsRenderingEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserContentsRendering", optionValue: ColumnChooserContentsRenderingEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserContentsRendered"): ColumnChooserContentsRenderedEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserContentsRendered", optionValue: ColumnChooserContentsRenderedEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonApplyClick"): ColumnChooserButtonApplyClickEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonApplyClick", optionValue: ColumnChooserButtonApplyClickEvent): void;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonResetClick"): ColumnChooserButtonResetClickEvent;
	igGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonResetClick", optionValue: ColumnChooserButtonResetClickEvent): void;
	igGridHiding(options: IgGridHiding): JQuery;
	igGridHiding(optionLiteral: 'option', optionName: string): any;
	igGridHiding(optionLiteral: 'option', options: IgGridHiding): JQuery;
	igGridHiding(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridHiding(methodName: string, ...methodParams: any[]): any;
}
interface IgHierarchicalGridColumnLayouts {
	key?: string;
	primaryKey?: string;
	foreignKey?: string;
}

interface RowExpandingEvent {
	(event: Event, ui: RowExpandingEventUIParam): void;
}

interface RowExpandingEventUIParam {
	owner?: any;
	parentrow?: any;
}

interface RowExpandedEvent {
	(event: Event, ui: RowExpandedEventUIParam): void;
}

interface RowExpandedEventUIParam {
	owner?: any;
	parentrow?: any;
}

interface RowCollapsingEvent {
	(event: Event, ui: RowCollapsingEventUIParam): void;
}

interface RowCollapsingEventUIParam {
	owner?: any;
	parentrow?: any;
}

interface RowCollapsedEvent {
	(event: Event, ui: RowCollapsedEventUIParam): void;
}

interface RowCollapsedEventUIParam {
	owner?: any;
	parentrow?: any;
}

interface ChildrenPopulatingEvent {
	(event: Event, ui: ChildrenPopulatingEventUIParam): void;
}

interface ChildrenPopulatingEventUIParam {
	owner?: any;
	parentrow?: any;
	id?: any;
}

interface ChildrenPopulatedEvent {
	(event: Event, ui: ChildrenPopulatedEventUIParam): void;
}

interface ChildrenPopulatedEventUIParam {
	owner?: any;
	parentrow?: any;
	id?: any;
}

interface ChildGridRenderedEvent {
	(event: Event, ui: ChildGridRenderedEventUIParam): void;
}

interface ChildGridRenderedEventUIParam {
	owner?: any;
	parentrow?: any;
	childgrid?: any;
}

interface ChildGridCreatingEvent {
	(event: Event, ui: ChildGridCreatingEventUIParam): void;
}

interface ChildGridCreatingEventUIParam {
}

interface ChildGridCreatedEvent {
	(event: Event, ui: ChildGridCreatedEventUIParam): void;
}

interface ChildGridCreatedEventUIParam {
}

interface IgHierarchicalGrid {
	initialDataBindDepth?: number;
	initialExpandDepth?: number;
	odata?: boolean;
	rest?: boolean;
	maxDataBindDepth?: number;
	defaultChildrenDataProperty?: string;
	autoGenerateLayouts?: boolean;
	expandCollapseAnimations?: boolean;
	expandColWidth?: number;
	pathSeparator?: string;
	animationDuration?: number;
	expandTooltip?: string;
	collapseTooltip?: string;
	columns?: any[];
	columnLayouts?: IgHierarchicalGridColumnLayouts;
	rowExpanding?: RowExpandingEvent;
	rowExpanded?: RowExpandedEvent;
	rowCollapsing?: RowCollapsingEvent;
	rowCollapsed?: RowCollapsedEvent;
	childrenPopulating?: ChildrenPopulatingEvent;
	childrenPopulated?: ChildrenPopulatedEvent;
	childGridRendered?: ChildGridRenderedEvent;
	childGridCreating?: ChildGridCreatingEvent;
	childGridCreated?: ChildGridCreatedEvent;
}
interface IgHierarchicalGridMethods {
	dataBind(): void;
	root(): Object;
	rootWidget(): Object;
	allChildrenWidgets(): Object;
	allChildren(): Object;
	toggle(element: Element, callback?: Function): void;
	expand(id: Element, callback?: Function): void;
	expanded(element: Element): boolean;
	collapse(id: Element, callback?: Function): void;
	collapsed(element: Element): boolean;
	populated(element: Element): boolean;
	commit(): void;
	rollback(rebind?: boolean): void;
	saveChanges(success: Function, error: Function): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igHierarchicalGrid"):IgHierarchicalGridMethods;
}

interface JQuery {
	igHierarchicalGrid(methodName: "dataBind"): void;
	igHierarchicalGrid(methodName: "root"): Object;
	igHierarchicalGrid(methodName: "rootWidget"): Object;
	igHierarchicalGrid(methodName: "allChildrenWidgets"): Object;
	igHierarchicalGrid(methodName: "allChildren"): Object;
	igHierarchicalGrid(methodName: "toggle", element: Element, callback?: Function): void;
	igHierarchicalGrid(methodName: "expand", id: Element, callback?: Function): void;
	igHierarchicalGrid(methodName: "expanded", element: Element): boolean;
	igHierarchicalGrid(methodName: "collapse", id: Element, callback?: Function): void;
	igHierarchicalGrid(methodName: "collapsed", element: Element): boolean;
	igHierarchicalGrid(methodName: "populated", element: Element): boolean;
	igHierarchicalGrid(methodName: "commit"): void;
	igHierarchicalGrid(methodName: "rollback", rebind?: boolean): void;
	igHierarchicalGrid(methodName: "saveChanges", success: Function, error: Function): void;
	igHierarchicalGrid(methodName: "destroy"): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "initialDataBindDepth"): number;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "initialDataBindDepth", optionValue: number): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "initialExpandDepth"): number;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "initialExpandDepth", optionValue: number): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "odata"): boolean;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "odata", optionValue: boolean): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "rest"): boolean;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "rest", optionValue: boolean): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "maxDataBindDepth"): number;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "maxDataBindDepth", optionValue: number): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "defaultChildrenDataProperty"): string;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "defaultChildrenDataProperty", optionValue: string): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "autoGenerateLayouts"): boolean;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "autoGenerateLayouts", optionValue: boolean): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "expandCollapseAnimations"): boolean;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "expandCollapseAnimations", optionValue: boolean): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "expandColWidth"): number;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "expandColWidth", optionValue: number): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "pathSeparator"): string;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "pathSeparator", optionValue: string): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "animationDuration"): number;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "animationDuration", optionValue: number): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "expandTooltip"): string;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "expandTooltip", optionValue: string): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "collapseTooltip"): string;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "collapseTooltip", optionValue: string): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "columns"): any[];
	igHierarchicalGrid(optionLiteral: 'option', optionName: "columns", optionValue: any[]): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "columnLayouts"): IgHierarchicalGridColumnLayouts;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "columnLayouts", optionValue: IgHierarchicalGridColumnLayouts): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "rowExpanding"): RowExpandingEvent;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "rowExpanding", optionValue: RowExpandingEvent): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "rowExpanded"): RowExpandedEvent;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "rowExpanded", optionValue: RowExpandedEvent): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "rowCollapsing"): RowCollapsingEvent;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "rowCollapsing", optionValue: RowCollapsingEvent): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "rowCollapsed"): RowCollapsedEvent;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "rowCollapsed", optionValue: RowCollapsedEvent): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "childrenPopulating"): ChildrenPopulatingEvent;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "childrenPopulating", optionValue: ChildrenPopulatingEvent): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "childrenPopulated"): ChildrenPopulatedEvent;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "childrenPopulated", optionValue: ChildrenPopulatedEvent): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "childGridRendered"): ChildGridRenderedEvent;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "childGridRendered", optionValue: ChildGridRenderedEvent): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "childGridCreating"): ChildGridCreatingEvent;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "childGridCreating", optionValue: ChildGridCreatingEvent): void;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "childGridCreated"): ChildGridCreatedEvent;
	igHierarchicalGrid(optionLiteral: 'option', optionName: "childGridCreated", optionValue: ChildGridCreatedEvent): void;
	igHierarchicalGrid(options: IgHierarchicalGrid): JQuery;
	igHierarchicalGrid(optionLiteral: 'option', optionName: string): any;
	igHierarchicalGrid(optionLiteral: 'option', options: IgHierarchicalGrid): JQuery;
	igHierarchicalGrid(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igHierarchicalGrid(methodName: string, ...methodParams: any[]): any;
}
interface IgGridMultiColumnHeaders {
	inherit?: boolean;
}
interface IgGridMultiColumnHeadersMethods {
	getMultiColumnHeaders(): any[];
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igGridMultiColumnHeaders"):IgGridMultiColumnHeadersMethods;
}

interface JQuery {
	igGridMultiColumnHeaders(methodName: "getMultiColumnHeaders"): any[];
	igGridMultiColumnHeaders(methodName: "destroy"): void;
	igGridMultiColumnHeaders(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridMultiColumnHeaders(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridMultiColumnHeaders(options: IgGridMultiColumnHeaders): JQuery;
	igGridMultiColumnHeaders(optionLiteral: 'option', optionName: string): any;
	igGridMultiColumnHeaders(optionLiteral: 'option', options: IgGridMultiColumnHeaders): JQuery;
	igGridMultiColumnHeaders(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridMultiColumnHeaders(methodName: string, ...methodParams: any[]): any;
}
interface PageIndexChangingEvent {
	(event: Event, ui: PageIndexChangingEventUIParam): void;
}

interface PageIndexChangingEventUIParam {
	owner?: any;
	currentPageIndex?: any;
	newPageIndex?: any;
}

interface PageIndexChangedEvent {
	(event: Event, ui: PageIndexChangedEventUIParam): void;
}

interface PageIndexChangedEventUIParam {
	owner?: any;
	pageIndex?: any;
}

interface PageSizeChangingEvent {
	(event: Event, ui: PageSizeChangingEventUIParam): void;
}

interface PageSizeChangingEventUIParam {
	owner?: any;
	currentPageSize?: any;
	newPageSize?: any;
}

interface PageSizeChangedEvent {
	(event: Event, ui: PageSizeChangedEventUIParam): void;
}

interface PageSizeChangedEventUIParam {
	owner?: any;
	pageSize?: any;
}

interface PagerRenderingEvent {
	(event: Event, ui: PagerRenderingEventUIParam): void;
}

interface PagerRenderingEventUIParam {
	owner?: any;
	dataSource?: any;
}

interface PagerRenderedEvent {
	(event: Event, ui: PagerRenderedEventUIParam): void;
}

interface PagerRenderedEventUIParam {
	owner?: any;
	dataSource?: any;
}

interface IgGridPaging {
	pageSize?: number;
	recordCountKey?: string;
	pageSizeUrlKey?: string;
	pageIndexUrlKey?: string;
	currentPageIndex?: number;
	type?: any;
	showPageSizeDropDown?: boolean;
	pageSizeDropDownLabel?: string;
	pageSizeDropDownTrailingLabel?: string;
	pageSizeDropDownLocation?: any;
	showPagerRecordsLabel?: boolean;
	pagerRecordsLabelTemplate?: string;
	nextPageLabelText?: string;
	prevPageLabelText?: string;
	firstPageLabelText?: string;
	lastPageLabelText?: string;
	showFirstLastPages?: boolean;
	showPrevNextPages?: boolean;
	currentPageDropDownLeadingLabel?: string;
	currentPageDropDownTrailingLabel?: string;
	currentPageDropDownTooltip?: string;
	pageSizeDropDownTooltip?: string;
	pagerRecordsLabelTooltip?: string;
	prevPageTooltip?: string;
	nextPageTooltip?: string;
	firstPageTooltip?: string;
	lastPageTooltip?: string;
	pageTooltipFormat?: string;
	pageSizeList?: any[];
	pageCountLimit?: number;
	visiblePageCount?: number;
	defaultDropDownWidth?: number;
	delayOnPageChanged?: number;
	persist?: boolean;
	inherit?: boolean;
	pageIndexChanging?: PageIndexChangingEvent;
	pageIndexChanged?: PageIndexChangedEvent;
	pageSizeChanging?: PageSizeChangingEvent;
	pageSizeChanged?: PageSizeChangedEvent;
	pagerRendering?: PagerRenderingEvent;
	pagerRendered?: PagerRenderedEvent;
}
interface IgGridPagingMethods {
	pageIndex(index?: number): number;
	pageSize(size?: number): number;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igGridPaging"):IgGridPagingMethods;
}

interface JQuery {
	igGridPaging(methodName: "pageIndex", index?: number): number;
	igGridPaging(methodName: "pageSize", size?: number): number;
	igGridPaging(methodName: "destroy"): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageSize"): number;
	igGridPaging(optionLiteral: 'option', optionName: "pageSize", optionValue: number): void;
	igGridPaging(optionLiteral: 'option', optionName: "recordCountKey"): string;
	igGridPaging(optionLiteral: 'option', optionName: "recordCountKey", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeUrlKey"): string;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeUrlKey", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageIndexUrlKey"): string;
	igGridPaging(optionLiteral: 'option', optionName: "pageIndexUrlKey", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "currentPageIndex"): number;
	igGridPaging(optionLiteral: 'option', optionName: "currentPageIndex", optionValue: number): void;
	igGridPaging(optionLiteral: 'option', optionName: "type"): any;
	igGridPaging(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igGridPaging(optionLiteral: 'option', optionName: "showPageSizeDropDown"): boolean;
	igGridPaging(optionLiteral: 'option', optionName: "showPageSizeDropDown", optionValue: boolean): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownLabel"): string;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownLabel", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownTrailingLabel"): string;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownTrailingLabel", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownLocation"): any;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownLocation", optionValue: any): void;
	igGridPaging(optionLiteral: 'option', optionName: "showPagerRecordsLabel"): boolean;
	igGridPaging(optionLiteral: 'option', optionName: "showPagerRecordsLabel", optionValue: boolean): void;
	igGridPaging(optionLiteral: 'option', optionName: "pagerRecordsLabelTemplate"): string;
	igGridPaging(optionLiteral: 'option', optionName: "pagerRecordsLabelTemplate", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "nextPageLabelText"): string;
	igGridPaging(optionLiteral: 'option', optionName: "nextPageLabelText", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "prevPageLabelText"): string;
	igGridPaging(optionLiteral: 'option', optionName: "prevPageLabelText", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "firstPageLabelText"): string;
	igGridPaging(optionLiteral: 'option', optionName: "firstPageLabelText", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "lastPageLabelText"): string;
	igGridPaging(optionLiteral: 'option', optionName: "lastPageLabelText", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "showFirstLastPages"): boolean;
	igGridPaging(optionLiteral: 'option', optionName: "showFirstLastPages", optionValue: boolean): void;
	igGridPaging(optionLiteral: 'option', optionName: "showPrevNextPages"): boolean;
	igGridPaging(optionLiteral: 'option', optionName: "showPrevNextPages", optionValue: boolean): void;
	igGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownLeadingLabel"): string;
	igGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownLeadingLabel", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownTrailingLabel"): string;
	igGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownTrailingLabel", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownTooltip"): string;
	igGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownTooltip", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownTooltip"): string;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownTooltip", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "pagerRecordsLabelTooltip"): string;
	igGridPaging(optionLiteral: 'option', optionName: "pagerRecordsLabelTooltip", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "prevPageTooltip"): string;
	igGridPaging(optionLiteral: 'option', optionName: "prevPageTooltip", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "nextPageTooltip"): string;
	igGridPaging(optionLiteral: 'option', optionName: "nextPageTooltip", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "firstPageTooltip"): string;
	igGridPaging(optionLiteral: 'option', optionName: "firstPageTooltip", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "lastPageTooltip"): string;
	igGridPaging(optionLiteral: 'option', optionName: "lastPageTooltip", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageTooltipFormat"): string;
	igGridPaging(optionLiteral: 'option', optionName: "pageTooltipFormat", optionValue: string): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeList"): any[];
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeList", optionValue: any[]): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageCountLimit"): number;
	igGridPaging(optionLiteral: 'option', optionName: "pageCountLimit", optionValue: number): void;
	igGridPaging(optionLiteral: 'option', optionName: "visiblePageCount"): number;
	igGridPaging(optionLiteral: 'option', optionName: "visiblePageCount", optionValue: number): void;
	igGridPaging(optionLiteral: 'option', optionName: "defaultDropDownWidth"): number;
	igGridPaging(optionLiteral: 'option', optionName: "defaultDropDownWidth", optionValue: number): void;
	igGridPaging(optionLiteral: 'option', optionName: "delayOnPageChanged"): number;
	igGridPaging(optionLiteral: 'option', optionName: "delayOnPageChanged", optionValue: number): void;
	igGridPaging(optionLiteral: 'option', optionName: "persist"): boolean;
	igGridPaging(optionLiteral: 'option', optionName: "persist", optionValue: boolean): void;
	igGridPaging(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridPaging(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageIndexChanging"): PageIndexChangingEvent;
	igGridPaging(optionLiteral: 'option', optionName: "pageIndexChanging", optionValue: PageIndexChangingEvent): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageIndexChanged"): PageIndexChangedEvent;
	igGridPaging(optionLiteral: 'option', optionName: "pageIndexChanged", optionValue: PageIndexChangedEvent): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeChanging"): PageSizeChangingEvent;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeChanging", optionValue: PageSizeChangingEvent): void;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeChanged"): PageSizeChangedEvent;
	igGridPaging(optionLiteral: 'option', optionName: "pageSizeChanged", optionValue: PageSizeChangedEvent): void;
	igGridPaging(optionLiteral: 'option', optionName: "pagerRendering"): PagerRenderingEvent;
	igGridPaging(optionLiteral: 'option', optionName: "pagerRendering", optionValue: PagerRenderingEvent): void;
	igGridPaging(optionLiteral: 'option', optionName: "pagerRendered"): PagerRenderedEvent;
	igGridPaging(optionLiteral: 'option', optionName: "pagerRendered", optionValue: PagerRenderedEvent): void;
	igGridPaging(options: IgGridPaging): JQuery;
	igGridPaging(optionLiteral: 'option', optionName: string): any;
	igGridPaging(optionLiteral: 'option', options: IgGridPaging): JQuery;
	igGridPaging(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridPaging(methodName: string, ...methodParams: any[]): any;
}
interface IgGridResizingColumnSetting {
	columnKey?: string;
	columnIndex?: number;
	allowResizing?: boolean;
	minimumWidth?: any;
	maximumWidth?: any;
}

interface ColumnResizingEvent {
	(event: Event, ui: ColumnResizingEventUIParam): void;
}

interface ColumnResizingEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
	desiredWidth?: any;
}

interface ColumnResizingRefusedEvent {
	(event: Event, ui: ColumnResizingRefusedEventUIParam): void;
}

interface ColumnResizingRefusedEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
	desiredWidth?: any;
}

interface ColumnResizedEvent {
	(event: Event, ui: ColumnResizedEventUIParam): void;
}

interface ColumnResizedEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
	originalWidth?: any;
	newWidth?: any;
}

interface IgGridResizing {
	allowDoubleClickToResize?: boolean;
	deferredResizing?: boolean;
	columnSettings?: IgGridResizingColumnSetting[];
	handleThreshold?: number;
	inherit?: boolean;
	columnResizing?: ColumnResizingEvent;
	columnResizingRefused?: ColumnResizingRefusedEvent;
	columnResized?: ColumnResizedEvent;
}
interface IgGridResizingMethods {
	destroy(): void;
	resize(column: Object, width?: Object): void;
}
interface JQuery {
	data(propertyName: "igGridResizing"):IgGridResizingMethods;
}

interface JQuery {
	igGridResizing(methodName: "destroy"): void;
	igGridResizing(methodName: "resize", column: Object, width?: Object): void;
	igGridResizing(optionLiteral: 'option', optionName: "allowDoubleClickToResize"): boolean;
	igGridResizing(optionLiteral: 'option', optionName: "allowDoubleClickToResize", optionValue: boolean): void;
	igGridResizing(optionLiteral: 'option', optionName: "deferredResizing"): boolean;
	igGridResizing(optionLiteral: 'option', optionName: "deferredResizing", optionValue: boolean): void;
	igGridResizing(optionLiteral: 'option', optionName: "columnSettings"): IgGridResizingColumnSetting[];
	igGridResizing(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridResizingColumnSetting[]): void;
	igGridResizing(optionLiteral: 'option', optionName: "handleThreshold"): number;
	igGridResizing(optionLiteral: 'option', optionName: "handleThreshold", optionValue: number): void;
	igGridResizing(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridResizing(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridResizing(optionLiteral: 'option', optionName: "columnResizing"): ColumnResizingEvent;
	igGridResizing(optionLiteral: 'option', optionName: "columnResizing", optionValue: ColumnResizingEvent): void;
	igGridResizing(optionLiteral: 'option', optionName: "columnResizingRefused"): ColumnResizingRefusedEvent;
	igGridResizing(optionLiteral: 'option', optionName: "columnResizingRefused", optionValue: ColumnResizingRefusedEvent): void;
	igGridResizing(optionLiteral: 'option', optionName: "columnResized"): ColumnResizedEvent;
	igGridResizing(optionLiteral: 'option', optionName: "columnResized", optionValue: ColumnResizedEvent): void;
	igGridResizing(options: IgGridResizing): JQuery;
	igGridResizing(optionLiteral: 'option', optionName: string): any;
	igGridResizing(optionLiteral: 'option', options: IgGridResizing): JQuery;
	igGridResizing(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridResizing(methodName: string, ...methodParams: any[]): any;
}
interface IgGridResponsiveColumnSetting {
	columnKey?: string;
	columnIndex?: number;
	classes?: string;
	configuration?: any;
}

interface IgGridResponsiveAllowedColumnWidthPerType {
	string?: number;
	number?: number;
	bool?: number;
	date?: number;
	object?: number;
}

interface ResponsiveColumnHidingEvent {
	(event: Event, ui: ResponsiveColumnHidingEventUIParam): void;
}

interface ResponsiveColumnHidingEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
}

interface ResponsiveColumnHiddenEvent {
	(event: Event, ui: ResponsiveColumnHiddenEventUIParam): void;
}

interface ResponsiveColumnHiddenEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
}

interface ResponsiveColumnShowingEvent {
	(event: Event, ui: ResponsiveColumnShowingEventUIParam): void;
}

interface ResponsiveColumnShowingEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
}

interface ResponsiveColumnShownEvent {
	(event: Event, ui: ResponsiveColumnShownEventUIParam): void;
}

interface ResponsiveColumnShownEventUIParam {
	owner?: any;
	columnIndex?: any;
	columnKey?: any;
}

interface ResponsiveModeChangedEvent {
	(event: Event, ui: ResponsiveModeChangedEventUIParam): void;
}

interface ResponsiveModeChangedEventUIParam {
	owner?: any;
	previousMode?: any;
	mode?: any;
}

interface IgGridResponsive {
	columnSettings?: IgGridResponsiveColumnSetting[];
	reactOnContainerWidthChanges?: boolean;
	forceResponsiveGridWidth?: boolean;
	responsiveSensitivity?: number;
	responsiveModes?: any;
	enableVerticalRendering?: boolean;
	windowWidthToRenderVertically?: any;
	propertiesColumnWidth?: any;
	valuesColumnWidth?: any;
	allowedColumnWidthPerType?: IgGridResponsiveAllowedColumnWidthPerType;
	singleColumnTemplate?: any;
	inherit?: boolean;
	responsiveColumnHiding?: ResponsiveColumnHidingEvent;
	responsiveColumnHidden?: ResponsiveColumnHiddenEvent;
	responsiveColumnShowing?: ResponsiveColumnShowingEvent;
	responsiveColumnShown?: ResponsiveColumnShownEvent;
	responsiveModeChanged?: ResponsiveModeChangedEvent;
}
interface IgGridResponsiveMethods {
	destroy(): void;
	getCurrentResponsiveMode(): void;
}
interface JQuery {
	data(propertyName: "igGridResponsive"):IgGridResponsiveMethods;
}

interface ResponsiveModeSettings {
	minWidth?: number;
	maxWidth?: any;
	minHeight?: number;
	maxHeight?: any;
}

declare module Infragistics {
export class ResponsiveMode  {
	constructor(settings: ResponsiveModeSettings);
}
}
interface IgniteUIStatic {
ResponsiveMode(settings: ResponsiveModeSettings): void;
}

interface InfragisticsModeSettings {
	key?: string;
	visibilityTester?: any;
}

declare module Infragistics {
export class InfragisticsMode extends ResponsiveMode {
	constructor(settings: InfragisticsModeSettings);
	constructor(settings: ResponsiveModeSettings);
}
}
interface IgniteUIStatic {
InfragisticsMode(settings: ResponsiveModeSettings): void;
}

interface BootstrapModeSettings {
	key?: string;
	visibilityTester?: any;
}

declare module Infragistics {
export class BootstrapMode extends ResponsiveMode {
	constructor(settings: BootstrapModeSettings);
	constructor(settings: ResponsiveModeSettings);
}
}
interface IgniteUIStatic {
BootstrapMode(settings: ResponsiveModeSettings): void;
}

interface JQuery {
	igGridResponsive(methodName: "destroy"): void;
	igGridResponsive(methodName: "getCurrentResponsiveMode"): void;
	igGridResponsive(optionLiteral: 'option', optionName: "columnSettings"): IgGridResponsiveColumnSetting[];
	igGridResponsive(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridResponsiveColumnSetting[]): void;
	igGridResponsive(optionLiteral: 'option', optionName: "reactOnContainerWidthChanges"): boolean;
	igGridResponsive(optionLiteral: 'option', optionName: "reactOnContainerWidthChanges", optionValue: boolean): void;
	igGridResponsive(optionLiteral: 'option', optionName: "forceResponsiveGridWidth"): boolean;
	igGridResponsive(optionLiteral: 'option', optionName: "forceResponsiveGridWidth", optionValue: boolean): void;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveSensitivity"): number;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveSensitivity", optionValue: number): void;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveModes"): any;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveModes", optionValue: any): void;
	igGridResponsive(optionLiteral: 'option', optionName: "enableVerticalRendering"): boolean;
	igGridResponsive(optionLiteral: 'option', optionName: "enableVerticalRendering", optionValue: boolean): void;
	igGridResponsive(optionLiteral: 'option', optionName: "windowWidthToRenderVertically"): any;
	igGridResponsive(optionLiteral: 'option', optionName: "windowWidthToRenderVertically", optionValue: any): void;
	igGridResponsive(optionLiteral: 'option', optionName: "propertiesColumnWidth"): any;
	igGridResponsive(optionLiteral: 'option', optionName: "propertiesColumnWidth", optionValue: any): void;
	igGridResponsive(optionLiteral: 'option', optionName: "valuesColumnWidth"): any;
	igGridResponsive(optionLiteral: 'option', optionName: "valuesColumnWidth", optionValue: any): void;
	igGridResponsive(optionLiteral: 'option', optionName: "allowedColumnWidthPerType"): IgGridResponsiveAllowedColumnWidthPerType;
	igGridResponsive(optionLiteral: 'option', optionName: "allowedColumnWidthPerType", optionValue: IgGridResponsiveAllowedColumnWidthPerType): void;
	igGridResponsive(optionLiteral: 'option', optionName: "singleColumnTemplate"): any;
	igGridResponsive(optionLiteral: 'option', optionName: "singleColumnTemplate", optionValue: any): void;
	igGridResponsive(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridResponsive(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveColumnHiding"): ResponsiveColumnHidingEvent;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveColumnHiding", optionValue: ResponsiveColumnHidingEvent): void;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveColumnHidden"): ResponsiveColumnHiddenEvent;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveColumnHidden", optionValue: ResponsiveColumnHiddenEvent): void;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveColumnShowing"): ResponsiveColumnShowingEvent;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveColumnShowing", optionValue: ResponsiveColumnShowingEvent): void;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveColumnShown"): ResponsiveColumnShownEvent;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveColumnShown", optionValue: ResponsiveColumnShownEvent): void;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveModeChanged"): ResponsiveModeChangedEvent;
	igGridResponsive(optionLiteral: 'option', optionName: "responsiveModeChanged", optionValue: ResponsiveModeChangedEvent): void;
	igGridResponsive(options: IgGridResponsive): JQuery;
	igGridResponsive(optionLiteral: 'option', optionName: string): any;
	igGridResponsive(optionLiteral: 'option', options: IgGridResponsive): JQuery;
	igGridResponsive(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridResponsive(methodName: string, ...methodParams: any[]): any;
}
interface RowSelectorClickedEvent {
	(event: Event, ui: RowSelectorClickedEventUIParam): void;
}

interface RowSelectorClickedEventUIParam {
	row?: any;
	fixedRow?: any;
	rowIndex?: any;
	rowKey?: any;
	rowSelector?: any;
	owner?: any;
	grid?: any;
}

interface CheckBoxStateChangingEvent {
	(event: Event, ui: CheckBoxStateChangingEventUIParam): void;
}

interface CheckBoxStateChangingEventUIParam {
	row?: any;
	rowIndex?: any;
	rowKey?: any;
	rowSelector?: any;
	owner?: any;
	grid?: any;
	currentState?: any;
	newState?: any;
	isHeader?: any;
}

interface CheckBoxStateChangedEvent {
	(event: Event, ui: CheckBoxStateChangedEventUIParam): void;
}

interface CheckBoxStateChangedEventUIParam {
	row?: any;
	rowIndex?: any;
	rowKey?: any;
	rowSelector?: any;
	owner?: any;
	grid?: any;
	state?: any;
	isHeader?: any;
}

interface IgGridRowSelectors {
	enableRowNumbering?: boolean;
	enableCheckBoxes?: boolean;
	rowNumberingSeed?: number;
	rowSelectorColumnWidth?: any;
	requireSelection?: boolean;
	showCheckBoxesOnFocus?: boolean;
	inherit?: boolean;
	rowSelectorClicked?: RowSelectorClickedEvent;
	checkBoxStateChanging?: CheckBoxStateChangingEvent;
	checkBoxStateChanged?: CheckBoxStateChangedEvent;
}
interface IgGridRowSelectorsMethods {
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igGridRowSelectors"):IgGridRowSelectorsMethods;
}

interface JQuery {
	igGridRowSelectors(methodName: "destroy"): void;
	igGridRowSelectors(optionLiteral: 'option', optionName: "enableRowNumbering"): boolean;
	igGridRowSelectors(optionLiteral: 'option', optionName: "enableRowNumbering", optionValue: boolean): void;
	igGridRowSelectors(optionLiteral: 'option', optionName: "enableCheckBoxes"): boolean;
	igGridRowSelectors(optionLiteral: 'option', optionName: "enableCheckBoxes", optionValue: boolean): void;
	igGridRowSelectors(optionLiteral: 'option', optionName: "rowNumberingSeed"): number;
	igGridRowSelectors(optionLiteral: 'option', optionName: "rowNumberingSeed", optionValue: number): void;
	igGridRowSelectors(optionLiteral: 'option', optionName: "rowSelectorColumnWidth"): any;
	igGridRowSelectors(optionLiteral: 'option', optionName: "rowSelectorColumnWidth", optionValue: any): void;
	igGridRowSelectors(optionLiteral: 'option', optionName: "requireSelection"): boolean;
	igGridRowSelectors(optionLiteral: 'option', optionName: "requireSelection", optionValue: boolean): void;
	igGridRowSelectors(optionLiteral: 'option', optionName: "showCheckBoxesOnFocus"): boolean;
	igGridRowSelectors(optionLiteral: 'option', optionName: "showCheckBoxesOnFocus", optionValue: boolean): void;
	igGridRowSelectors(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridRowSelectors(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridRowSelectors(optionLiteral: 'option', optionName: "rowSelectorClicked"): RowSelectorClickedEvent;
	igGridRowSelectors(optionLiteral: 'option', optionName: "rowSelectorClicked", optionValue: RowSelectorClickedEvent): void;
	igGridRowSelectors(optionLiteral: 'option', optionName: "checkBoxStateChanging"): CheckBoxStateChangingEvent;
	igGridRowSelectors(optionLiteral: 'option', optionName: "checkBoxStateChanging", optionValue: CheckBoxStateChangingEvent): void;
	igGridRowSelectors(optionLiteral: 'option', optionName: "checkBoxStateChanged"): CheckBoxStateChangedEvent;
	igGridRowSelectors(optionLiteral: 'option', optionName: "checkBoxStateChanged", optionValue: CheckBoxStateChangedEvent): void;
	igGridRowSelectors(options: IgGridRowSelectors): JQuery;
	igGridRowSelectors(optionLiteral: 'option', optionName: string): any;
	igGridRowSelectors(optionLiteral: 'option', options: IgGridRowSelectors): JQuery;
	igGridRowSelectors(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridRowSelectors(methodName: string, ...methodParams: any[]): any;
}
interface RowSelectionChangingEvent {
	(event: Event, ui: RowSelectionChangingEventUIParam): void;
}

interface RowSelectionChangingEventUIParam {
	owner?: any;
	selectedRows?: any;
	startIndex?: any;
	endIndex?: any;
}

interface RowSelectionChangedEvent {
	(event: Event, ui: RowSelectionChangedEventUIParam): void;
}

interface RowSelectionChangedEventUIParam {
	owner?: any;
	selectedRows?: any;
}

interface CellSelectionChangingEvent {
	(event: Event, ui: CellSelectionChangingEventUIParam): void;
}

interface CellSelectionChangingEventUIParam {
	owner?: any;
	selectedCells?: any;
	firstColumnIndex?: any;
	firstRowIndex?: any;
	lastColumnIndex?: any;
	lastRowIndex?: any;
}

interface CellSelectionChangedEvent {
	(event: Event, ui: CellSelectionChangedEventUIParam): void;
}

interface CellSelectionChangedEventUIParam {
	owner?: any;
	selectedCells?: any;
}

interface ActiveCellChangingEvent {
	(event: Event, ui: ActiveCellChangingEventUIParam): void;
}

interface ActiveCellChangingEventUIParam {
	owner?: any;
}

interface ActiveCellChangedEvent {
	(event: Event, ui: ActiveCellChangedEventUIParam): void;
}

interface ActiveCellChangedEventUIParam {
	owner?: any;
}

interface ActiveRowChangingEvent {
	(event: Event, ui: ActiveRowChangingEventUIParam): void;
}

interface ActiveRowChangingEventUIParam {
	owner?: any;
}

interface ActiveRowChangedEvent {
	(event: Event, ui: ActiveRowChangedEventUIParam): void;
}

interface ActiveRowChangedEventUIParam {
	owner?: any;
}

interface IgGridSelection {
	multipleSelection?: boolean;
	mouseDragSelect?: boolean;
	mode?: any;
	activation?: boolean;
	wrapAround?: boolean;
	skipChildren?: boolean;
	multipleCellSelectOnClick?: boolean;
	touchDragSelect?: boolean;
	persist?: boolean;
	allowMultipleRangeSelection?: boolean;
	rowSelectionChanging?: RowSelectionChangingEvent;
	rowSelectionChanged?: RowSelectionChangedEvent;
	cellSelectionChanging?: CellSelectionChangingEvent;
	cellSelectionChanged?: CellSelectionChangedEvent;
	activeCellChanging?: ActiveCellChangingEvent;
	activeCellChanged?: ActiveCellChangedEvent;
	activeRowChanging?: ActiveRowChangingEvent;
	activeRowChanged?: ActiveRowChangedEvent;
}
interface IgGridSelectionMethods {
	destroy(): void;
	clearSelection(): void;
	selectCell(row: number, col: number, isFixed: Object): void;
	selectCellById(id: Object, colKey: string): void;
	deselectCell(row: number, col: number, isFixed: Object): void;
	deselectCellById(id: Object, colKey: string): void;
	selectRow(index: number): void;
	selectRowById(id: Object): void;
	deselectRow(index: number): void;
	deselectRowById(id: Object): void;
	selectedCells(): any[];
	selectedRows(): any[];
	selectedCell(): Object;
	selectedRow(): Object;
	activeCell(): Object;
	activeRow(): Object;
}
interface JQuery {
	data(propertyName: "igGridSelection"):IgGridSelectionMethods;
}

interface SelectionCollectionSettingsSubscribers {
}

interface SelectionCollectionSettings {
	multipleSelection?: boolean;
	subscribers?: SelectionCollectionSettingsSubscribers;
	owner?: any;
}

declare module Infragistics {
export class SelectionCollection  {
	constructor(settings: SelectionCollectionSettings);
}
}
interface IgniteUIStatic {
SelectionCollection(settings: SelectionCollectionSettings): void;
}

declare module Infragistics {
export class SelectedRowsCollection extends SelectionCollection {
	constructor(settings: SelectionCollectionSettings);
}
}
interface IgniteUIStatic {
SelectedRowsCollection(settings: SelectionCollectionSettings): void;
}

declare module Infragistics {
export class SelectedCellsCollection extends SelectionCollection {
	constructor(settings: SelectionCollectionSettings);
}
}
interface IgniteUIStatic {
SelectedCellsCollection(settings: SelectionCollectionSettings): void;
}

interface JQuery {
	igGridSelection(methodName: "destroy"): void;
	igGridSelection(methodName: "clearSelection"): void;
	igGridSelection(methodName: "selectCell", row: number, col: number, isFixed: Object): void;
	igGridSelection(methodName: "selectCellById", id: Object, colKey: string): void;
	igGridSelection(methodName: "deselectCell", row: number, col: number, isFixed: Object): void;
	igGridSelection(methodName: "deselectCellById", id: Object, colKey: string): void;
	igGridSelection(methodName: "selectRow", index: number): void;
	igGridSelection(methodName: "selectRowById", id: Object): void;
	igGridSelection(methodName: "deselectRow", index: number): void;
	igGridSelection(methodName: "deselectRowById", id: Object): void;
	igGridSelection(methodName: "selectedCells"): any[];
	igGridSelection(methodName: "selectedRows"): any[];
	igGridSelection(methodName: "selectedCell"): Object;
	igGridSelection(methodName: "selectedRow"): Object;
	igGridSelection(methodName: "activeCell"): Object;
	igGridSelection(methodName: "activeRow"): Object;
	igGridSelection(optionLiteral: 'option', optionName: "multipleSelection"): boolean;
	igGridSelection(optionLiteral: 'option', optionName: "multipleSelection", optionValue: boolean): void;
	igGridSelection(optionLiteral: 'option', optionName: "mouseDragSelect"): boolean;
	igGridSelection(optionLiteral: 'option', optionName: "mouseDragSelect", optionValue: boolean): void;
	igGridSelection(optionLiteral: 'option', optionName: "mode"): any;
	igGridSelection(optionLiteral: 'option', optionName: "mode", optionValue: any): void;
	igGridSelection(optionLiteral: 'option', optionName: "activation"): boolean;
	igGridSelection(optionLiteral: 'option', optionName: "activation", optionValue: boolean): void;
	igGridSelection(optionLiteral: 'option', optionName: "wrapAround"): boolean;
	igGridSelection(optionLiteral: 'option', optionName: "wrapAround", optionValue: boolean): void;
	igGridSelection(optionLiteral: 'option', optionName: "skipChildren"): boolean;
	igGridSelection(optionLiteral: 'option', optionName: "skipChildren", optionValue: boolean): void;
	igGridSelection(optionLiteral: 'option', optionName: "multipleCellSelectOnClick"): boolean;
	igGridSelection(optionLiteral: 'option', optionName: "multipleCellSelectOnClick", optionValue: boolean): void;
	igGridSelection(optionLiteral: 'option', optionName: "touchDragSelect"): boolean;
	igGridSelection(optionLiteral: 'option', optionName: "touchDragSelect", optionValue: boolean): void;
	igGridSelection(optionLiteral: 'option', optionName: "persist"): boolean;
	igGridSelection(optionLiteral: 'option', optionName: "persist", optionValue: boolean): void;
	igGridSelection(optionLiteral: 'option', optionName: "allowMultipleRangeSelection"): boolean;
	igGridSelection(optionLiteral: 'option', optionName: "allowMultipleRangeSelection", optionValue: boolean): void;
	igGridSelection(optionLiteral: 'option', optionName: "rowSelectionChanging"): RowSelectionChangingEvent;
	igGridSelection(optionLiteral: 'option', optionName: "rowSelectionChanging", optionValue: RowSelectionChangingEvent): void;
	igGridSelection(optionLiteral: 'option', optionName: "rowSelectionChanged"): RowSelectionChangedEvent;
	igGridSelection(optionLiteral: 'option', optionName: "rowSelectionChanged", optionValue: RowSelectionChangedEvent): void;
	igGridSelection(optionLiteral: 'option', optionName: "cellSelectionChanging"): CellSelectionChangingEvent;
	igGridSelection(optionLiteral: 'option', optionName: "cellSelectionChanging", optionValue: CellSelectionChangingEvent): void;
	igGridSelection(optionLiteral: 'option', optionName: "cellSelectionChanged"): CellSelectionChangedEvent;
	igGridSelection(optionLiteral: 'option', optionName: "cellSelectionChanged", optionValue: CellSelectionChangedEvent): void;
	igGridSelection(optionLiteral: 'option', optionName: "activeCellChanging"): ActiveCellChangingEvent;
	igGridSelection(optionLiteral: 'option', optionName: "activeCellChanging", optionValue: ActiveCellChangingEvent): void;
	igGridSelection(optionLiteral: 'option', optionName: "activeCellChanged"): ActiveCellChangedEvent;
	igGridSelection(optionLiteral: 'option', optionName: "activeCellChanged", optionValue: ActiveCellChangedEvent): void;
	igGridSelection(optionLiteral: 'option', optionName: "activeRowChanging"): ActiveRowChangingEvent;
	igGridSelection(optionLiteral: 'option', optionName: "activeRowChanging", optionValue: ActiveRowChangingEvent): void;
	igGridSelection(optionLiteral: 'option', optionName: "activeRowChanged"): ActiveRowChangedEvent;
	igGridSelection(optionLiteral: 'option', optionName: "activeRowChanged", optionValue: ActiveRowChangedEvent): void;
	igGridSelection(options: IgGridSelection): JQuery;
	igGridSelection(optionLiteral: 'option', optionName: string): any;
	igGridSelection(optionLiteral: 'option', options: IgGridSelection): JQuery;
	igGridSelection(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridSelection(methodName: string, ...methodParams: any[]): any;
}
interface IgGridSortingColumnSetting {
	columnKey?: string;
	columnIndex?: number;
	firstSortDirection?: any;
	currentSortDirection?: any;
	allowSorting?: boolean;
}

interface ColumnSortingEvent {
	(event: Event, ui: ColumnSortingEventUIParam): void;
}

interface ColumnSortingEventUIParam {
	owner?: any;
	columnKey?: any;
	direction?: any;
	newExpressions?: any;
}

interface ColumnSortedEvent {
	(event: Event, ui: ColumnSortedEventUIParam): void;
}

interface ColumnSortedEventUIParam {
	owner?: any;
	columnKey?: any;
	direction?: any;
	expressions?: any;
}

interface ModalDialogSortingChangedEvent {
	(event: Event, ui: ModalDialogSortingChangedEventUIParam): void;
}

interface ModalDialogSortingChangedEventUIParam {
	owner?: any;
	modalDialogElement?: any;
	columnKey?: any;
	isAsc?: any;
}

interface ModalDialogButtonUnsortClickEvent {
	(event: Event, ui: ModalDialogButtonUnsortClickEventUIParam): void;
}

interface ModalDialogButtonUnsortClickEventUIParam {
	owner?: any;
	modalDialogElement?: any;
	columnKey?: any;
}

interface ModalDialogSortClickEvent {
	(event: Event, ui: ModalDialogSortClickEventUIParam): void;
}

interface ModalDialogSortClickEventUIParam {
	owner?: any;
	modalDialogElement?: any;
	columnKey?: any;
}

interface IgGridSorting {
	type?: any;
	caseSensitive?: boolean;
	applySortedColumnCss?: boolean;
	sortUrlKey?: string;
	sortUrlKeyAscValue?: string;
	sortUrlKeyDescValue?: string;
	mode?: any;
	customSortFunction?: Function;
	firstSortDirection?: any;
	sortedColumnTooltip?: string;
	modalDialogSortOnClick?: boolean;
	modalDialogSortByButtonText?: string;
	modalDialogResetButtonLabel?: string;
	modalDialogCaptionButtonDesc?: string;
	modalDialogCaptionButtonAsc?: string;
	modalDialogCaptionButtonUnsort?: string;
	modalDialogWidth?: number;
	modalDialogHeight?: any;
	modalDialogAnimationDuration?: number;
	featureChooserText?: string;
	unsortedColumnTooltip?: string;
	columnSettings?: IgGridSortingColumnSetting[];
	modalDialogCaptionText?: string;
	modalDialogButtonApplyText?: string;
	modalDialogButtonCancelText?: string;
	featureChooserSortAsc?: any;
	featureChooserSortDesc?: any;
	persist?: boolean;
	sortingDialogContainment?: string;
	inherit?: boolean;
	columnSorting?: ColumnSortingEvent;
	columnSorted?: ColumnSortedEvent;
	modalDialogOpening?: ModalDialogOpeningEvent;
	modalDialogOpened?: ModalDialogOpenedEvent;
	modalDialogMoving?: ModalDialogMovingEvent;
	modalDialogClosing?: ModalDialogClosingEvent;
	modalDialogClosed?: ModalDialogClosedEvent;
	modalDialogContentsRendering?: ModalDialogContentsRenderingEvent;
	modalDialogContentsRendered?: ModalDialogContentsRenderedEvent;
	modalDialogSortingChanged?: ModalDialogSortingChangedEvent;
	modalDialogButtonUnsortClick?: ModalDialogButtonUnsortClickEvent;
	modalDialogSortClick?: ModalDialogSortClickEvent;
	modalDialogButtonApplyClick?: ModalDialogButtonApplyClickEvent;
	modalDialogButtonResetClick?: ModalDialogButtonResetClickEvent;
}
interface IgGridSortingMethods {
	sortColumn(index: Object, direction: Object, header: Object): void;
	sortMultiple(): void;
	clearSorting(): void;
	unsortColumn(index: Object, header: Object): void;
	destroy(): void;
	openMultipleSortingDialog(): void;
	closeMultipleSortingDialog(): void;
	renderMultipleSortingDialogContent(isToCallEvents: Object): void;
	removeDialogClearButton(): void;
}
interface JQuery {
	data(propertyName: "igGridSorting"):IgGridSortingMethods;
}

interface JQuery {
	igGridSorting(methodName: "sortColumn", index: Object, direction: Object, header: Object): void;
	igGridSorting(methodName: "sortMultiple"): void;
	igGridSorting(methodName: "clearSorting"): void;
	igGridSorting(methodName: "unsortColumn", index: Object, header: Object): void;
	igGridSorting(methodName: "destroy"): void;
	igGridSorting(methodName: "openMultipleSortingDialog"): void;
	igGridSorting(methodName: "closeMultipleSortingDialog"): void;
	igGridSorting(methodName: "renderMultipleSortingDialogContent", isToCallEvents: Object): void;
	igGridSorting(methodName: "removeDialogClearButton"): void;
	igGridSorting(optionLiteral: 'option', optionName: "type"): any;
	igGridSorting(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igGridSorting(optionLiteral: 'option', optionName: "caseSensitive"): boolean;
	igGridSorting(optionLiteral: 'option', optionName: "caseSensitive", optionValue: boolean): void;
	igGridSorting(optionLiteral: 'option', optionName: "applySortedColumnCss"): boolean;
	igGridSorting(optionLiteral: 'option', optionName: "applySortedColumnCss", optionValue: boolean): void;
	igGridSorting(optionLiteral: 'option', optionName: "sortUrlKey"): string;
	igGridSorting(optionLiteral: 'option', optionName: "sortUrlKey", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "sortUrlKeyAscValue"): string;
	igGridSorting(optionLiteral: 'option', optionName: "sortUrlKeyAscValue", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "sortUrlKeyDescValue"): string;
	igGridSorting(optionLiteral: 'option', optionName: "sortUrlKeyDescValue", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "mode"): any;
	igGridSorting(optionLiteral: 'option', optionName: "mode", optionValue: any): void;
	igGridSorting(optionLiteral: 'option', optionName: "customSortFunction"): Function;
	igGridSorting(optionLiteral: 'option', optionName: "customSortFunction", optionValue: Function): void;
	igGridSorting(optionLiteral: 'option', optionName: "firstSortDirection"): any;
	igGridSorting(optionLiteral: 'option', optionName: "firstSortDirection", optionValue: any): void;
	igGridSorting(optionLiteral: 'option', optionName: "sortedColumnTooltip"): string;
	igGridSorting(optionLiteral: 'option', optionName: "sortedColumnTooltip", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogSortOnClick"): boolean;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogSortOnClick", optionValue: boolean): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogSortByButtonText"): string;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogSortByButtonText", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogResetButtonLabel"): string;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogResetButtonLabel", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonDesc"): string;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonDesc", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonAsc"): string;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonAsc", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonUnsort"): string;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonUnsort", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogWidth"): number;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogWidth", optionValue: number): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogHeight"): any;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogHeight", optionValue: any): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogAnimationDuration"): number;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogAnimationDuration", optionValue: number): void;
	igGridSorting(optionLiteral: 'option', optionName: "featureChooserText"): string;
	igGridSorting(optionLiteral: 'option', optionName: "featureChooserText", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "unsortedColumnTooltip"): string;
	igGridSorting(optionLiteral: 'option', optionName: "unsortedColumnTooltip", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "columnSettings"): IgGridSortingColumnSetting[];
	igGridSorting(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridSortingColumnSetting[]): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionText"): string;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionText", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonApplyText"): string;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonApplyText", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonCancelText"): string;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonCancelText", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "featureChooserSortAsc"): any;
	igGridSorting(optionLiteral: 'option', optionName: "featureChooserSortAsc", optionValue: any): void;
	igGridSorting(optionLiteral: 'option', optionName: "featureChooserSortDesc"): any;
	igGridSorting(optionLiteral: 'option', optionName: "featureChooserSortDesc", optionValue: any): void;
	igGridSorting(optionLiteral: 'option', optionName: "persist"): boolean;
	igGridSorting(optionLiteral: 'option', optionName: "persist", optionValue: boolean): void;
	igGridSorting(optionLiteral: 'option', optionName: "sortingDialogContainment"): string;
	igGridSorting(optionLiteral: 'option', optionName: "sortingDialogContainment", optionValue: string): void;
	igGridSorting(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridSorting(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridSorting(optionLiteral: 'option', optionName: "columnSorting"): ColumnSortingEvent;
	igGridSorting(optionLiteral: 'option', optionName: "columnSorting", optionValue: ColumnSortingEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "columnSorted"): ColumnSortedEvent;
	igGridSorting(optionLiteral: 'option', optionName: "columnSorted", optionValue: ColumnSortedEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogOpening"): ModalDialogOpeningEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogOpening", optionValue: ModalDialogOpeningEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogOpened"): ModalDialogOpenedEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogOpened", optionValue: ModalDialogOpenedEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogMoving"): ModalDialogMovingEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogMoving", optionValue: ModalDialogMovingEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogClosing"): ModalDialogClosingEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogClosing", optionValue: ModalDialogClosingEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogClosed"): ModalDialogClosedEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogClosed", optionValue: ModalDialogClosedEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogContentsRendering"): ModalDialogContentsRenderingEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogContentsRendering", optionValue: ModalDialogContentsRenderingEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogContentsRendered"): ModalDialogContentsRenderedEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogContentsRendered", optionValue: ModalDialogContentsRenderedEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogSortingChanged"): ModalDialogSortingChangedEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogSortingChanged", optionValue: ModalDialogSortingChangedEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonUnsortClick"): ModalDialogButtonUnsortClickEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonUnsortClick", optionValue: ModalDialogButtonUnsortClickEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogSortClick"): ModalDialogSortClickEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogSortClick", optionValue: ModalDialogSortClickEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonApplyClick"): ModalDialogButtonApplyClickEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonApplyClick", optionValue: ModalDialogButtonApplyClickEvent): void;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonResetClick"): ModalDialogButtonResetClickEvent;
	igGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonResetClick", optionValue: ModalDialogButtonResetClickEvent): void;
	igGridSorting(options: IgGridSorting): JQuery;
	igGridSorting(optionLiteral: 'option', optionName: string): any;
	igGridSorting(optionLiteral: 'option', options: IgGridSorting): JQuery;
	igGridSorting(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridSorting(methodName: string, ...methodParams: any[]): any;
}
interface IgGridSummariesColumnSettingSummaryOperand {
	rowDisplayLabel?: string;
	type?: any;
	active?: boolean;
	summaryCalculator?: string;
	order?: number;
	decimalDisplay?: number;
	isGridFormatter?: boolean;
}

interface IgGridSummariesColumnSetting {
	allowSummaries?: boolean;
	columnKey?: string;
	columnIndex?: number;
	summaryOperands?: IgGridSummariesColumnSettingSummaryOperand[];
}

interface SummariesCalculatingEvent {
	(event: Event, ui: SummariesCalculatingEventUIParam): void;
}

interface SummariesCalculatingEventUIParam {
	owner?: any;
}

interface SummariesCalculatedEvent {
	(event: Event, ui: SummariesCalculatedEventUIParam): void;
}

interface SummariesCalculatedEventUIParam {
	data?: any;
	owner?: any;
}

interface SummariesMethodSelectionChangedEvent {
	(event: Event, ui: SummariesMethodSelectionChangedEventUIParam): void;
}

interface SummariesMethodSelectionChangedEventUIParam {
	columnKey?: any;
	isSelected?: any;
	methodName?: any;
	owner?: any;
}

interface SummariesTogglingEvent {
	(event: Event, ui: SummariesTogglingEventUIParam): void;
}

interface SummariesTogglingEventUIParam {
	isToShow?: any;
	owner?: any;
}

interface SummariesToggledEvent {
	(event: Event, ui: SummariesToggledEventUIParam): void;
}

interface SummariesToggledEventUIParam {
	isToShow?: any;
	owner?: any;
}

interface DropDownOKClickedEvent {
	(event: Event, ui: DropDownOKClickedEventUIParam): void;
}

interface DropDownOKClickedEventUIParam {
	columnKey?: any;
	eventData?: any;
	owner?: any;
}

interface DropDownCancelClickedEvent {
	(event: Event, ui: DropDownCancelClickedEventUIParam): void;
}

interface DropDownCancelClickedEventUIParam {
	columnKey?: any;
	owner?: any;
}

interface IgGridSummaries {
	type?: any;
	dialogButtonOKText?: string;
	dialogButtonCancelText?: string;
	calculateRenderMode?: any;
	featureChooserText?: string;
	featureChooserTextHide?: string;
	compactRenderingMode?: any;
	defaultDecimalDisplay?: number;
	showSummariesButton?: boolean;
	summariesResponseKey?: string;
	summaryExprUrlKey?: string;
	callee?: Function;
	dropDownHeight?: number;
	dropDownWidth?: number;
	showDropDownButton?: boolean;
	summaryExecution?: any;
	dropDownDialogAnimationDuration?: number;
	emptyCellText?: string;
	summariesHeaderButtonTooltip?: string;
	resultTemplate?: string;
	isGridFormatter?: boolean;
	renderSummaryCellFunc?: any;
	columnSettings?: IgGridSummariesColumnSetting[];
	inherit?: boolean;
	dropDownOpening?: DropDownOpeningEvent;
	dropDownOpened?: DropDownOpenedEvent;
	dropDownClosing?: DropDownClosingEvent;
	dropDownClosed?: DropDownClosedEvent;
	summariesCalculating?: SummariesCalculatingEvent;
	summariesCalculated?: SummariesCalculatedEvent;
	summariesMethodSelectionChanged?: SummariesMethodSelectionChangedEvent;
	summariesToggling?: SummariesTogglingEvent;
	summariesToggled?: SummariesToggledEvent;
	dropDownOKClicked?: DropDownOKClickedEvent;
	dropDownCancelClicked?: DropDownCancelClickedEvent;
}
interface IgGridSummariesMethods {
	destroy(): void;
	isSummariesRowsHidden(): void;
	calculateSummaries(): void;
	clearAllFooterIcons(): void;
	toggleDropDown(columnKey: string, event: Object): void;
	showHideDialog($dialog: Object): void;
	toggleSummariesRows(isToShow: boolean, isInternalCall: boolean): void;
	toggleCheckstate($checkbox: Object): void;
	selectCheckBox($checkbox: Object, isToSelect: boolean): void;
	calculateSummaryColumn(ck: string, columnMethods: any[], data: Object, dataType: Object): void;
	summaryCollection(): void;
	summariesFor(columnKey: Object): void;
}
interface JQuery {
	data(propertyName: "igGridSummaries"):IgGridSummariesMethods;
}

interface JQuery {
	igGridSummaries(methodName: "destroy"): void;
	igGridSummaries(methodName: "isSummariesRowsHidden"): void;
	igGridSummaries(methodName: "calculateSummaries"): void;
	igGridSummaries(methodName: "clearAllFooterIcons"): void;
	igGridSummaries(methodName: "toggleDropDown", columnKey: string, event: Object): void;
	igGridSummaries(methodName: "showHideDialog", $dialog: Object): void;
	igGridSummaries(methodName: "toggleSummariesRows", isToShow: boolean, isInternalCall: boolean): void;
	igGridSummaries(methodName: "toggleCheckstate", $checkbox: Object): void;
	igGridSummaries(methodName: "selectCheckBox", $checkbox: Object, isToSelect: boolean): void;
	igGridSummaries(methodName: "calculateSummaryColumn", ck: string, columnMethods: any[], data: Object, dataType: Object): void;
	igGridSummaries(methodName: "summaryCollection"): void;
	igGridSummaries(methodName: "summariesFor", columnKey: Object): void;
	igGridSummaries(optionLiteral: 'option', optionName: "type"): any;
	igGridSummaries(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igGridSummaries(optionLiteral: 'option', optionName: "dialogButtonOKText"): string;
	igGridSummaries(optionLiteral: 'option', optionName: "dialogButtonOKText", optionValue: string): void;
	igGridSummaries(optionLiteral: 'option', optionName: "dialogButtonCancelText"): string;
	igGridSummaries(optionLiteral: 'option', optionName: "dialogButtonCancelText", optionValue: string): void;
	igGridSummaries(optionLiteral: 'option', optionName: "calculateRenderMode"): any;
	igGridSummaries(optionLiteral: 'option', optionName: "calculateRenderMode", optionValue: any): void;
	igGridSummaries(optionLiteral: 'option', optionName: "featureChooserText"): string;
	igGridSummaries(optionLiteral: 'option', optionName: "featureChooserText", optionValue: string): void;
	igGridSummaries(optionLiteral: 'option', optionName: "featureChooserTextHide"): string;
	igGridSummaries(optionLiteral: 'option', optionName: "featureChooserTextHide", optionValue: string): void;
	igGridSummaries(optionLiteral: 'option', optionName: "compactRenderingMode"): any;
	igGridSummaries(optionLiteral: 'option', optionName: "compactRenderingMode", optionValue: any): void;
	igGridSummaries(optionLiteral: 'option', optionName: "defaultDecimalDisplay"): number;
	igGridSummaries(optionLiteral: 'option', optionName: "defaultDecimalDisplay", optionValue: number): void;
	igGridSummaries(optionLiteral: 'option', optionName: "showSummariesButton"): boolean;
	igGridSummaries(optionLiteral: 'option', optionName: "showSummariesButton", optionValue: boolean): void;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesResponseKey"): string;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesResponseKey", optionValue: string): void;
	igGridSummaries(optionLiteral: 'option', optionName: "summaryExprUrlKey"): string;
	igGridSummaries(optionLiteral: 'option', optionName: "summaryExprUrlKey", optionValue: string): void;
	igGridSummaries(optionLiteral: 'option', optionName: "callee"): Function;
	igGridSummaries(optionLiteral: 'option', optionName: "callee", optionValue: Function): void;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownHeight"): number;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownHeight", optionValue: number): void;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownWidth"): number;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownWidth", optionValue: number): void;
	igGridSummaries(optionLiteral: 'option', optionName: "showDropDownButton"): boolean;
	igGridSummaries(optionLiteral: 'option', optionName: "showDropDownButton", optionValue: boolean): void;
	igGridSummaries(optionLiteral: 'option', optionName: "summaryExecution"): any;
	igGridSummaries(optionLiteral: 'option', optionName: "summaryExecution", optionValue: any): void;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownDialogAnimationDuration"): number;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownDialogAnimationDuration", optionValue: number): void;
	igGridSummaries(optionLiteral: 'option', optionName: "emptyCellText"): string;
	igGridSummaries(optionLiteral: 'option', optionName: "emptyCellText", optionValue: string): void;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesHeaderButtonTooltip"): string;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesHeaderButtonTooltip", optionValue: string): void;
	igGridSummaries(optionLiteral: 'option', optionName: "resultTemplate"): string;
	igGridSummaries(optionLiteral: 'option', optionName: "resultTemplate", optionValue: string): void;
	igGridSummaries(optionLiteral: 'option', optionName: "isGridFormatter"): boolean;
	igGridSummaries(optionLiteral: 'option', optionName: "isGridFormatter", optionValue: boolean): void;
	igGridSummaries(optionLiteral: 'option', optionName: "renderSummaryCellFunc"): any;
	igGridSummaries(optionLiteral: 'option', optionName: "renderSummaryCellFunc", optionValue: any): void;
	igGridSummaries(optionLiteral: 'option', optionName: "columnSettings"): IgGridSummariesColumnSetting[];
	igGridSummaries(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridSummariesColumnSetting[]): void;
	igGridSummaries(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridSummaries(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownOpening"): DropDownOpeningEvent;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownOpening", optionValue: DropDownOpeningEvent): void;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownOpened"): DropDownOpenedEvent;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownOpened", optionValue: DropDownOpenedEvent): void;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownClosing"): DropDownClosingEvent;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownClosing", optionValue: DropDownClosingEvent): void;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownClosed"): DropDownClosedEvent;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownClosed", optionValue: DropDownClosedEvent): void;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesCalculating"): SummariesCalculatingEvent;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesCalculating", optionValue: SummariesCalculatingEvent): void;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesCalculated"): SummariesCalculatedEvent;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesCalculated", optionValue: SummariesCalculatedEvent): void;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesMethodSelectionChanged"): SummariesMethodSelectionChangedEvent;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesMethodSelectionChanged", optionValue: SummariesMethodSelectionChangedEvent): void;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesToggling"): SummariesTogglingEvent;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesToggling", optionValue: SummariesTogglingEvent): void;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesToggled"): SummariesToggledEvent;
	igGridSummaries(optionLiteral: 'option', optionName: "summariesToggled", optionValue: SummariesToggledEvent): void;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownOKClicked"): DropDownOKClickedEvent;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownOKClicked", optionValue: DropDownOKClickedEvent): void;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownCancelClicked"): DropDownCancelClickedEvent;
	igGridSummaries(optionLiteral: 'option', optionName: "dropDownCancelClicked", optionValue: DropDownCancelClickedEvent): void;
	igGridSummaries(options: IgGridSummaries): JQuery;
	igGridSummaries(optionLiteral: 'option', optionName: string): any;
	igGridSummaries(optionLiteral: 'option', options: IgGridSummaries): JQuery;
	igGridSummaries(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridSummaries(methodName: string, ...methodParams: any[]): any;
}
interface IgGridTooltipsColumnSettings {
	columnKey?: string;
	columnIndex?: number;
	allowTooltips?: boolean;
	maxWidth?: number;
}

interface IgGridTooltips {
	visibility?: any;
	style?: any;
	showDelay?: number;
	hideDelay?: number;
	columnSettings?: IgGridTooltipsColumnSettings;
	fadeTimespan?: number;
	cursorLeftOffset?: number;
	cursorTopOffset?: number;
	inherit?: boolean;
	tooltipShowing?: TooltipShowingEvent;
	tooltipShown?: TooltipShownEvent;
	tooltipHiding?: TooltipHidingEvent;
	tooltipHidden?: TooltipHiddenEvent;
}
interface IgGridTooltipsMethods {
	destroy(): void;
	id(): string;
}
interface JQuery {
	data(propertyName: "igGridTooltips"):IgGridTooltipsMethods;
}

interface JQuery {
	igGridTooltips(methodName: "destroy"): void;
	igGridTooltips(methodName: "id"): string;
	igGridTooltips(optionLiteral: 'option', optionName: "visibility"): any;
	igGridTooltips(optionLiteral: 'option', optionName: "visibility", optionValue: any): void;
	igGridTooltips(optionLiteral: 'option', optionName: "style"): any;
	igGridTooltips(optionLiteral: 'option', optionName: "style", optionValue: any): void;
	igGridTooltips(optionLiteral: 'option', optionName: "showDelay"): number;
	igGridTooltips(optionLiteral: 'option', optionName: "showDelay", optionValue: number): void;
	igGridTooltips(optionLiteral: 'option', optionName: "hideDelay"): number;
	igGridTooltips(optionLiteral: 'option', optionName: "hideDelay", optionValue: number): void;
	igGridTooltips(optionLiteral: 'option', optionName: "columnSettings"): IgGridTooltipsColumnSettings;
	igGridTooltips(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridTooltipsColumnSettings): void;
	igGridTooltips(optionLiteral: 'option', optionName: "fadeTimespan"): number;
	igGridTooltips(optionLiteral: 'option', optionName: "fadeTimespan", optionValue: number): void;
	igGridTooltips(optionLiteral: 'option', optionName: "cursorLeftOffset"): number;
	igGridTooltips(optionLiteral: 'option', optionName: "cursorLeftOffset", optionValue: number): void;
	igGridTooltips(optionLiteral: 'option', optionName: "cursorTopOffset"): number;
	igGridTooltips(optionLiteral: 'option', optionName: "cursorTopOffset", optionValue: number): void;
	igGridTooltips(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridTooltips(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridTooltips(optionLiteral: 'option', optionName: "tooltipShowing"): TooltipShowingEvent;
	igGridTooltips(optionLiteral: 'option', optionName: "tooltipShowing", optionValue: TooltipShowingEvent): void;
	igGridTooltips(optionLiteral: 'option', optionName: "tooltipShown"): TooltipShownEvent;
	igGridTooltips(optionLiteral: 'option', optionName: "tooltipShown", optionValue: TooltipShownEvent): void;
	igGridTooltips(optionLiteral: 'option', optionName: "tooltipHiding"): TooltipHidingEvent;
	igGridTooltips(optionLiteral: 'option', optionName: "tooltipHiding", optionValue: TooltipHidingEvent): void;
	igGridTooltips(optionLiteral: 'option', optionName: "tooltipHidden"): TooltipHiddenEvent;
	igGridTooltips(optionLiteral: 'option', optionName: "tooltipHidden", optionValue: TooltipHiddenEvent): void;
	igGridTooltips(options: IgGridTooltips): JQuery;
	igGridTooltips(optionLiteral: 'option', optionName: string): any;
	igGridTooltips(optionLiteral: 'option', options: IgGridTooltips): JQuery;
	igGridTooltips(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridTooltips(methodName: string, ...methodParams: any[]): any;
}
interface IgGridUpdatingColumnSetting {
	columnKey?: string;
	editorType?: any;
	editorProvider?: any;
	editorOptions?: any;
	required?: boolean;
	readOnly?: boolean;
	validation?: boolean;
	defaultValue?: any;
}

interface EditRowStartingEvent {
	(event: Event, ui: EditRowStartingEventUIParam): void;
}

interface EditRowStartingEventUIParam {
	owner?: any;
	rowID?: any;
	rowAdding?: any;
}

interface EditRowStartedEvent {
	(event: Event, ui: EditRowStartedEventUIParam): void;
}

interface EditRowStartedEventUIParam {
	owner?: any;
	rowID?: any;
	rowAdding?: any;
}

interface EditRowEndingEvent {
	(event: Event, ui: EditRowEndingEventUIParam): void;
}

interface EditRowEndingEventUIParam {
	owner?: any;
	rowID?: any;
	keepEditing?: any;
	update?: any;
	rowAdding?: any;
	values?: any;
	oldValues?: any;
}

interface EditRowEndedEvent {
	(event: Event, ui: EditRowEndedEventUIParam): void;
}

interface EditRowEndedEventUIParam {
	owner?: any;
	rowID?: any;
	update?: any;
	rowAdding?: any;
	values?: any;
	oldValues?: any;
}

interface EditCellStartingEvent {
	(event: Event, ui: EditCellStartingEventUIParam): void;
}

interface EditCellStartingEventUIParam {
	owner?: any;
	rowID?: any;
	columnIndex?: any;
	columnKey?: any;
	editor?: any;
	value?: any;
	rowAdding?: any;
}

interface EditCellStartedEvent {
	(event: Event, ui: EditCellStartedEventUIParam): void;
}

interface EditCellStartedEventUIParam {
	owner?: any;
	rowID?: any;
	columnIndex?: any;
	columnKey?: any;
	editor?: any;
	value?: any;
	rowAdding?: any;
}

interface EditCellEndingEvent {
	(event: Event, ui: EditCellEndingEventUIParam): void;
}

interface EditCellEndingEventUIParam {
	owner?: any;
	rowID?: any;
	columnIndex?: any;
	columnKey?: any;
	keepEditing?: any;
	editor?: any;
	value?: any;
	oldValue?: any;
	update?: any;
	rowAdding?: any;
}

interface EditCellEndedEvent {
	(event: Event, ui: EditCellEndedEventUIParam): void;
}

interface EditCellEndedEventUIParam {
	owner?: any;
	rowID?: any;
	columnIndex?: any;
	columnKey?: any;
	editor?: any;
	value?: any;
	oldValue?: any;
	update?: any;
	rowAdding?: any;
}

interface RowAddingEvent {
	(event: Event, ui: RowAddingEventUIParam): void;
}

interface RowAddingEventUIParam {
	owner?: any;
	values?: any;
	oldValues?: any;
}

interface RowAddedEvent {
	(event: Event, ui: RowAddedEventUIParam): void;
}

interface RowAddedEventUIParam {
	owner?: any;
	values?: any;
	oldValues?: any;
}

interface RowDeletingEvent {
	(event: Event, ui: RowDeletingEventUIParam): void;
}

interface RowDeletingEventUIParam {
	owner?: any;
	element?: any;
	rowID?: any;
}

interface RowDeletedEvent {
	(event: Event, ui: RowDeletedEventUIParam): void;
}

interface RowDeletedEventUIParam {
	owner?: any;
	element?: any;
	rowID?: any;
}

interface DataDirtyEvent {
	(event: Event, ui: DataDirtyEventUIParam): void;
}

interface DataDirtyEventUIParam {
	owner?: any;
}

interface GeneratePrimaryKeyValueEvent {
	(event: Event, ui: GeneratePrimaryKeyValueEventUIParam): void;
}

interface GeneratePrimaryKeyValueEventUIParam {
	owner?: any;
	value?: any;
}

interface RowEditDialogOpeningEvent {
	(event: Event, ui: RowEditDialogOpeningEventUIParam): void;
}

interface RowEditDialogOpeningEventUIParam {
	owner?: any;
	dialogElement?: any;
}

interface RowEditDialogOpenedEvent {
	(event: Event, ui: RowEditDialogOpenedEventUIParam): void;
}

interface RowEditDialogOpenedEventUIParam {
	owner?: any;
	dialogElement?: any;
}

interface RowEditDialogContentsRenderingEvent {
	(event: Event, ui: RowEditDialogContentsRenderingEventUIParam): void;
}

interface RowEditDialogContentsRenderingEventUIParam {
	owner?: any;
	dialogElement?: any;
}

interface RowEditDialogContentsRenderedEvent {
	(event: Event, ui: RowEditDialogContentsRenderedEventUIParam): void;
}

interface RowEditDialogContentsRenderedEventUIParam {
	owner?: any;
	dialogElement?: any;
}

interface RowEditDialogClosingEvent {
	(event: Event, ui: RowEditDialogClosingEventUIParam): void;
}

interface RowEditDialogClosingEventUIParam {
	owner?: any;
	dialogElement?: any;
}

interface RowEditDialogClosedEvent {
	(event: Event, ui: RowEditDialogClosedEventUIParam): void;
}

interface RowEditDialogClosedEventUIParam {
	owner?: any;
	dialogElement?: any;
}

interface IgGridUpdating {
	columnSettings?: IgGridUpdatingColumnSetting[];
	editMode?: any;
	showReadonlyEditors?: boolean;
	enableDeleteRow?: boolean;
	enableAddRow?: boolean;
	validation?: boolean;
	doneLabel?: string;
	doneTooltip?: string;
	cancelLabel?: string;
	cancelTooltip?: string;
	addRowLabel?: string;
	addRowTooltip?: string;
	deleteRowLabel?: string;
	deleteRowTooltip?: string;
	rowEditDialogCaptionLabel?: string;
	showDoneCancelButtons?: boolean;
	enableDataDirtyException?: boolean;
	rowEditDialogContentHeight?: any;
	rowEditDialogFieldWidth?: number;
	rowEditDialogWidth?: any;
	rowEditDialogHeight?: any;
	startEditTriggers?: string;
	rowEditDialogContainment?: string;
	rowEditDialogOkCancelButtonWidth?: any;
	rowEditDialogRowTemplate?: string;
	rowEditDialogRowTemplateID?: string;
	horizontalMoveOnEnter?: boolean;
	excelNavigationMode?: boolean;
	saveChangesSuccessHandler?: any;
	saveChangesErrorHandler?: any;
	swipeDistance?: any;
	inherit?: boolean;
	editRowStarting?: EditRowStartingEvent;
	editRowStarted?: EditRowStartedEvent;
	editRowEnding?: EditRowEndingEvent;
	editRowEnded?: EditRowEndedEvent;
	editCellStarting?: EditCellStartingEvent;
	editCellStarted?: EditCellStartedEvent;
	editCellEnding?: EditCellEndingEvent;
	editCellEnded?: EditCellEndedEvent;
	rowAdding?: RowAddingEvent;
	rowAdded?: RowAddedEvent;
	rowDeleting?: RowDeletingEvent;
	rowDeleted?: RowDeletedEvent;
	dataDirty?: DataDirtyEvent;
	generatePrimaryKeyValue?: GeneratePrimaryKeyValueEvent;
	rowEditDialogOpening?: RowEditDialogOpeningEvent;
	rowEditDialogOpened?: RowEditDialogOpenedEvent;
	rowEditDialogContentsRendering?: RowEditDialogContentsRenderingEvent;
	rowEditDialogContentsRendered?: RowEditDialogContentsRenderedEvent;
	rowEditDialogClosing?: RowEditDialogClosingEvent;
	rowEditDialogClosed?: RowEditDialogClosedEvent;
}
interface IgGridUpdatingMethods {
	setCellValue(rowId: Object, colKey: string, value: Object, tr?: Element): void;
	updateRow(rowId: Object, values: Object, tr?: Element): void;
	addRow(values: Object): void;
	deleteRow(rowId: Object, tr?: Element): void;
	startEdit(row: Object, col: Object, e?: boolean): boolean;
	startAddRowEdit(e?: boolean): boolean;
	endEdit(update?: boolean, e?: boolean): boolean;
	findInvalid(): void;
	isEditing(): boolean;
	editorForKey(key: Object): Object;
	editorForCell(td: string, add?: boolean): Object;
	findHiddenComboEditor(editor: string): Object;
	destroy(): Object;
}
interface JQuery {
	data(propertyName: "igGridUpdating"):IgGridUpdatingMethods;
}

interface IgEditorFilter {
}
interface IgEditorFilterMethods {
	setFocus(delay: Object, toggle: Object): void;
	remove(): void;
	validator(): void;
	hasInvalidMessage(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igEditorFilter"):IgEditorFilterMethods;
}

declare module Infragistics {
export class EditorProvider  {
}
}

declare module Infragistics {
export class EditorProviderDefault extends EditorProvider {
}
}

declare module Infragistics {
export class EditorProviderCombo extends EditorProvider {
}
}

declare module Infragistics {
export class EditorProviderRating extends EditorProvider {
}
}

declare module Infragistics {
export class EditorProviderCheckbox extends EditorProvider {
}
}

interface JQuery {
	igGridUpdating(methodName: "setCellValue", rowId: Object, colKey: string, value: Object, tr?: Element): void;
	igGridUpdating(methodName: "updateRow", rowId: Object, values: Object, tr?: Element): void;
	igGridUpdating(methodName: "addRow", values: Object): void;
	igGridUpdating(methodName: "deleteRow", rowId: Object, tr?: Element): void;
	igGridUpdating(methodName: "startEdit", row: Object, col: Object, e?: boolean): boolean;
	igGridUpdating(methodName: "startAddRowEdit", e?: boolean): boolean;
	igGridUpdating(methodName: "endEdit", update?: boolean, e?: boolean): boolean;
	igGridUpdating(methodName: "findInvalid"): void;
	igGridUpdating(methodName: "isEditing"): boolean;
	igGridUpdating(methodName: "editorForKey", key: Object): Object;
	igGridUpdating(methodName: "editorForCell", td: string, add?: boolean): Object;
	igGridUpdating(methodName: "findHiddenComboEditor", editor: string): Object;
	igGridUpdating(methodName: "destroy"): Object;
	igGridUpdating(optionLiteral: 'option', optionName: "columnSettings"): IgGridUpdatingColumnSetting[];
	igGridUpdating(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridUpdatingColumnSetting[]): void;
	igGridUpdating(optionLiteral: 'option', optionName: "editMode"): any;
	igGridUpdating(optionLiteral: 'option', optionName: "editMode", optionValue: any): void;
	igGridUpdating(optionLiteral: 'option', optionName: "showReadonlyEditors"): boolean;
	igGridUpdating(optionLiteral: 'option', optionName: "showReadonlyEditors", optionValue: boolean): void;
	igGridUpdating(optionLiteral: 'option', optionName: "enableDeleteRow"): boolean;
	igGridUpdating(optionLiteral: 'option', optionName: "enableDeleteRow", optionValue: boolean): void;
	igGridUpdating(optionLiteral: 'option', optionName: "enableAddRow"): boolean;
	igGridUpdating(optionLiteral: 'option', optionName: "enableAddRow", optionValue: boolean): void;
	igGridUpdating(optionLiteral: 'option', optionName: "validation"): boolean;
	igGridUpdating(optionLiteral: 'option', optionName: "validation", optionValue: boolean): void;
	igGridUpdating(optionLiteral: 'option', optionName: "doneLabel"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "doneLabel", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "doneTooltip"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "doneTooltip", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "cancelLabel"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "cancelLabel", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "cancelTooltip"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "cancelTooltip", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "addRowLabel"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "addRowLabel", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "addRowTooltip"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "addRowTooltip", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "deleteRowLabel"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "deleteRowLabel", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "deleteRowTooltip"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "deleteRowTooltip", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogCaptionLabel"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogCaptionLabel", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "showDoneCancelButtons"): boolean;
	igGridUpdating(optionLiteral: 'option', optionName: "showDoneCancelButtons", optionValue: boolean): void;
	igGridUpdating(optionLiteral: 'option', optionName: "enableDataDirtyException"): boolean;
	igGridUpdating(optionLiteral: 'option', optionName: "enableDataDirtyException", optionValue: boolean): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentHeight"): any;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentHeight", optionValue: any): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogFieldWidth"): number;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogFieldWidth", optionValue: number): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogWidth"): any;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogWidth", optionValue: any): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogHeight"): any;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogHeight", optionValue: any): void;
	igGridUpdating(optionLiteral: 'option', optionName: "startEditTriggers"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "startEditTriggers", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContainment"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContainment", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOkCancelButtonWidth"): any;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOkCancelButtonWidth", optionValue: any): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogRowTemplate"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogRowTemplate", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogRowTemplateID"): string;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogRowTemplateID", optionValue: string): void;
	igGridUpdating(optionLiteral: 'option', optionName: "horizontalMoveOnEnter"): boolean;
	igGridUpdating(optionLiteral: 'option', optionName: "horizontalMoveOnEnter", optionValue: boolean): void;
	igGridUpdating(optionLiteral: 'option', optionName: "excelNavigationMode"): boolean;
	igGridUpdating(optionLiteral: 'option', optionName: "excelNavigationMode", optionValue: boolean): void;
	igGridUpdating(optionLiteral: 'option', optionName: "saveChangesSuccessHandler"): any;
	igGridUpdating(optionLiteral: 'option', optionName: "saveChangesSuccessHandler", optionValue: any): void;
	igGridUpdating(optionLiteral: 'option', optionName: "saveChangesErrorHandler"): any;
	igGridUpdating(optionLiteral: 'option', optionName: "saveChangesErrorHandler", optionValue: any): void;
	igGridUpdating(optionLiteral: 'option', optionName: "swipeDistance"): any;
	igGridUpdating(optionLiteral: 'option', optionName: "swipeDistance", optionValue: any): void;
	igGridUpdating(optionLiteral: 'option', optionName: "inherit"): boolean;
	igGridUpdating(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igGridUpdating(optionLiteral: 'option', optionName: "editRowStarting"): EditRowStartingEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "editRowStarting", optionValue: EditRowStartingEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "editRowStarted"): EditRowStartedEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "editRowStarted", optionValue: EditRowStartedEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "editRowEnding"): EditRowEndingEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "editRowEnding", optionValue: EditRowEndingEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "editRowEnded"): EditRowEndedEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "editRowEnded", optionValue: EditRowEndedEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "editCellStarting"): EditCellStartingEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "editCellStarting", optionValue: EditCellStartingEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "editCellStarted"): EditCellStartedEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "editCellStarted", optionValue: EditCellStartedEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "editCellEnding"): EditCellEndingEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "editCellEnding", optionValue: EditCellEndingEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "editCellEnded"): EditCellEndedEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "editCellEnded", optionValue: EditCellEndedEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowAdding"): RowAddingEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "rowAdding", optionValue: RowAddingEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowAdded"): RowAddedEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "rowAdded", optionValue: RowAddedEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowDeleting"): RowDeletingEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "rowDeleting", optionValue: RowDeletingEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowDeleted"): RowDeletedEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "rowDeleted", optionValue: RowDeletedEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "dataDirty"): DataDirtyEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "dataDirty", optionValue: DataDirtyEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "generatePrimaryKeyValue"): GeneratePrimaryKeyValueEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "generatePrimaryKeyValue", optionValue: GeneratePrimaryKeyValueEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOpening"): RowEditDialogOpeningEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOpening", optionValue: RowEditDialogOpeningEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOpened"): RowEditDialogOpenedEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOpened", optionValue: RowEditDialogOpenedEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentsRendering"): RowEditDialogContentsRenderingEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentsRendering", optionValue: RowEditDialogContentsRenderingEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentsRendered"): RowEditDialogContentsRenderedEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentsRendered", optionValue: RowEditDialogContentsRenderedEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogClosing"): RowEditDialogClosingEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogClosing", optionValue: RowEditDialogClosingEvent): void;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogClosed"): RowEditDialogClosedEvent;
	igGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogClosed", optionValue: RowEditDialogClosedEvent): void;
	igGridUpdating(options: IgGridUpdating): JQuery;
	igGridUpdating(optionLiteral: 'option', optionName: string): any;
	igGridUpdating(optionLiteral: 'option', options: IgGridUpdating): JQuery;
	igGridUpdating(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igGridUpdating(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igEditorFilter(methodName: "setFocus", delay: Object, toggle: Object): void;
	igEditorFilter(methodName: "remove"): void;
	igEditorFilter(methodName: "validator"): void;
	igEditorFilter(methodName: "hasInvalidMessage"): void;
	igEditorFilter(methodName: "destroy"): void;
	igEditorFilter(options: IgEditorFilter): JQuery;
	igEditorFilter(optionLiteral: 'option', optionName: string): any;
	igEditorFilter(optionLiteral: 'option', options: IgEditorFilter): JQuery;
	igEditorFilter(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igEditorFilter(methodName: string, ...methodParams: any[]): any;
}
interface ActionExecutingEvent {
	(event: Event, ui: ActionExecutingEventUIParam): void;
}

interface ActionExecutingEventUIParam {
}

interface ActionExecutedEvent {
	(event: Event, ui: ActionExecutedEventUIParam): void;
}

interface ActionExecutedEventUIParam {
}

interface ToolbarCollapsingEvent {
	(event: Event, ui: ToolbarCollapsingEventUIParam): void;
}

interface ToolbarCollapsingEventUIParam {
}

interface ToolbarCollapsedEvent {
	(event: Event, ui: ToolbarCollapsedEventUIParam): void;
}

interface ToolbarCollapsedEventUIParam {
}

interface ToolbarExpandingEvent {
	(event: Event, ui: ToolbarExpandingEventUIParam): void;
}

interface ToolbarExpandingEventUIParam {
}

interface ToolbarExpandedEvent {
	(event: Event, ui: ToolbarExpandedEventUIParam): void;
}

interface ToolbarExpandedEventUIParam {
}

interface CutEvent {
	(event: Event, ui: CutEventUIParam): void;
}

interface CutEventUIParam {
}

interface CopyEvent {
	(event: Event, ui: CopyEventUIParam): void;
}

interface CopyEventUIParam {
}

interface PasteEvent {
	(event: Event, ui: PasteEventUIParam): void;
}

interface PasteEventUIParam {
}

interface UndoEvent {
	(event: Event, ui: UndoEventUIParam): void;
}

interface UndoEventUIParam {
}

interface RedoEvent {
	(event: Event, ui: RedoEventUIParam): void;
}

interface RedoEventUIParam {
}

interface WorkspaceResizedEvent {
	(event: Event, ui: WorkspaceResizedEventUIParam): void;
}

interface WorkspaceResizedEventUIParam {
}

interface IgHtmlEditor {
	showFormattingToolbar?: boolean;
	showTextToolbar?: boolean;
	showInsertObjectToolbar?: boolean;
	showCopyPasteToolbar?: boolean;
	width?: any;
	height?: any;
	toolbarSettings?: any[];
	customToolbars?: any[];
	inputName?: string;
	value?: string;
	rendered?: RenderedEvent;
	rendering?: RenderingEvent;
	actionExecuting?: ActionExecutingEvent;
	actionExecuted?: ActionExecutedEvent;
	toolbarCollapsing?: ToolbarCollapsingEvent;
	toolbarCollapsed?: ToolbarCollapsedEvent;
	toolbarExpanding?: ToolbarExpandingEvent;
	toolbarExpanded?: ToolbarExpandedEvent;
	cut?: CutEvent;
	copy?: CopyEvent;
	paste?: PasteEvent;
	undo?: UndoEvent;
	redo?: RedoEvent;
	workspaceResized?: WorkspaceResizedEvent;
}
interface IgHtmlEditorMethods {
	widget(): void;
	resizeWorkspace(): void;
	getContent(format: string): string;
	setContent(content: string, format: string): void;
	destroy(): void;
	executeAction(actionName: string, args?: Object): void;
	isDirty(): Object;
	contentWindow(): Object;
	contentDocument(): Object;
	contentEditable(): Object;
	selection(): Object;
	range(): Object;
	insertAtCaret(element: Object): void;
}
interface JQuery {
	data(propertyName: "igHtmlEditor"):IgHtmlEditorMethods;
}

interface IgPathFinder {
	items?: any;
}

interface ApplyEvent {
	(event: Event, ui: ApplyEventUIParam): void;
}

interface ApplyEventUIParam {
}

interface CancelEvent {
	(event: Event, ui: CancelEventUIParam): void;
}

interface CancelEventUIParam {
}

interface ShowEvent {
	(event: Event, ui: ShowEventUIParam): void;
}

interface ShowEventUIParam {
}

interface HideEvent {
	(event: Event, ui: HideEventUIParam): void;
}

interface HideEventUIParam {
}

interface IgHtmlEditorPopover {
	item?: any;
	target?: any;
	isHidden?: boolean;
	apply?: ApplyEvent;
	cancel?: CancelEvent;
	show?: ShowEvent;
	hide?: HideEvent;
}
interface IgHtmlEditorPopoverMethods {
	show(item: Object): void;
	hide(): void;
}
interface JQuery {
	data(propertyName: "igHtmlEditorPopover"):IgHtmlEditorPopoverMethods;
}

interface IgLinkPropertiesDialog {
	item?: any;
	target?: any;
	isHidden?: boolean;
	apply?: ApplyEvent;
	cancel?: CancelEvent;
	show?: ShowEvent;
	hide?: HideEvent;
}
interface IgLinkPropertiesDialogMethods {
	show(item: Object): void;
	hide(): void;
}
interface JQuery {
	data(propertyName: "igLinkPropertiesDialog"):IgLinkPropertiesDialogMethods;
}

interface IgTablePropertiesDialog {
	item?: any;
	target?: any;
	isHidden?: boolean;
	apply?: ApplyEvent;
	cancel?: CancelEvent;
	show?: ShowEvent;
	hide?: HideEvent;
}
interface IgTablePropertiesDialogMethods {
	show(item: Object): void;
	hide(): void;
}
interface JQuery {
	data(propertyName: "igTablePropertiesDialog"):IgTablePropertiesDialogMethods;
}

interface IgImagePropertiesDialog {
	item?: any;
	target?: any;
	isHidden?: boolean;
	apply?: ApplyEvent;
	cancel?: CancelEvent;
	show?: ShowEvent;
	hide?: HideEvent;
}
interface IgImagePropertiesDialogMethods {
	show(item: Object): void;
	hide(): void;
}
interface JQuery {
	data(propertyName: "igImagePropertiesDialog"):IgImagePropertiesDialogMethods;
}

declare module Infragistics {
export class SelectionWrapper  {
	constructor(NODE: any);
}
}
interface IgniteUIStatic {
SelectionWrapper(NODE: any): void;
}

declare module Infragistics {
export class ToolbarHelper  {
}
}

interface JQuery {
	igHtmlEditor(methodName: "widget"): void;
	igHtmlEditor(methodName: "resizeWorkspace"): void;
	igHtmlEditor(methodName: "getContent", format: string): string;
	igHtmlEditor(methodName: "setContent", content: string, format: string): void;
	igHtmlEditor(methodName: "destroy"): void;
	igHtmlEditor(methodName: "executeAction", actionName: string, args?: Object): void;
	igHtmlEditor(methodName: "isDirty"): Object;
	igHtmlEditor(methodName: "contentWindow"): Object;
	igHtmlEditor(methodName: "contentDocument"): Object;
	igHtmlEditor(methodName: "contentEditable"): Object;
	igHtmlEditor(methodName: "selection"): Object;
	igHtmlEditor(methodName: "range"): Object;
	igHtmlEditor(methodName: "insertAtCaret", element: Object): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "showFormattingToolbar"): boolean;
	igHtmlEditor(optionLiteral: 'option', optionName: "showFormattingToolbar", optionValue: boolean): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "showTextToolbar"): boolean;
	igHtmlEditor(optionLiteral: 'option', optionName: "showTextToolbar", optionValue: boolean): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "showInsertObjectToolbar"): boolean;
	igHtmlEditor(optionLiteral: 'option', optionName: "showInsertObjectToolbar", optionValue: boolean): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "showCopyPasteToolbar"): boolean;
	igHtmlEditor(optionLiteral: 'option', optionName: "showCopyPasteToolbar", optionValue: boolean): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "width"): any;
	igHtmlEditor(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "height"): any;
	igHtmlEditor(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "toolbarSettings"): any[];
	igHtmlEditor(optionLiteral: 'option', optionName: "toolbarSettings", optionValue: any[]): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "customToolbars"): any[];
	igHtmlEditor(optionLiteral: 'option', optionName: "customToolbars", optionValue: any[]): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "inputName"): string;
	igHtmlEditor(optionLiteral: 'option', optionName: "inputName", optionValue: string): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "value"): string;
	igHtmlEditor(optionLiteral: 'option', optionName: "value", optionValue: string): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "rendered"): RenderedEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "rendered", optionValue: RenderedEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "rendering"): RenderingEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "rendering", optionValue: RenderingEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "actionExecuting"): ActionExecutingEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "actionExecuting", optionValue: ActionExecutingEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "actionExecuted"): ActionExecutedEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "actionExecuted", optionValue: ActionExecutedEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "toolbarCollapsing"): ToolbarCollapsingEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "toolbarCollapsing", optionValue: ToolbarCollapsingEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "toolbarCollapsed"): ToolbarCollapsedEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "toolbarCollapsed", optionValue: ToolbarCollapsedEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "toolbarExpanding"): ToolbarExpandingEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "toolbarExpanding", optionValue: ToolbarExpandingEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "toolbarExpanded"): ToolbarExpandedEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "toolbarExpanded", optionValue: ToolbarExpandedEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "cut"): CutEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "cut", optionValue: CutEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "copy"): CopyEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "copy", optionValue: CopyEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "paste"): PasteEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "paste", optionValue: PasteEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "undo"): UndoEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "undo", optionValue: UndoEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "redo"): RedoEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "redo", optionValue: RedoEvent): void;
	igHtmlEditor(optionLiteral: 'option', optionName: "workspaceResized"): WorkspaceResizedEvent;
	igHtmlEditor(optionLiteral: 'option', optionName: "workspaceResized", optionValue: WorkspaceResizedEvent): void;
	igHtmlEditor(options: IgHtmlEditor): JQuery;
	igHtmlEditor(optionLiteral: 'option', optionName: string): any;
	igHtmlEditor(optionLiteral: 'option', options: IgHtmlEditor): JQuery;
	igHtmlEditor(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igHtmlEditor(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igPathFinder(optionLiteral: 'option', optionName: "items"): any;
	igPathFinder(optionLiteral: 'option', optionName: "items", optionValue: any): void;
	igPathFinder(options: IgPathFinder): JQuery;
	igPathFinder(optionLiteral: 'option', optionName: string): any;
	igPathFinder(optionLiteral: 'option', options: IgPathFinder): JQuery;
	igPathFinder(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igPathFinder(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igHtmlEditorPopover(methodName: "show", item: Object): void;
	igHtmlEditorPopover(methodName: "hide"): void;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "item"): any;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "item", optionValue: any): void;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "target"): any;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "target", optionValue: any): void;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "isHidden"): boolean;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "isHidden", optionValue: boolean): void;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "apply"): ApplyEvent;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "apply", optionValue: ApplyEvent): void;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "cancel"): CancelEvent;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "cancel", optionValue: CancelEvent): void;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "show"): ShowEvent;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "show", optionValue: ShowEvent): void;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "hide"): HideEvent;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: "hide", optionValue: HideEvent): void;
	igHtmlEditorPopover(options: IgHtmlEditorPopover): JQuery;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: string): any;
	igHtmlEditorPopover(optionLiteral: 'option', options: IgHtmlEditorPopover): JQuery;
	igHtmlEditorPopover(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igHtmlEditorPopover(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igLinkPropertiesDialog(methodName: "show", item: Object): void;
	igLinkPropertiesDialog(methodName: "hide"): void;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "item"): any;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "item", optionValue: any): void;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "target"): any;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "target", optionValue: any): void;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "isHidden"): boolean;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "isHidden", optionValue: boolean): void;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "apply"): ApplyEvent;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "apply", optionValue: ApplyEvent): void;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "cancel"): CancelEvent;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "cancel", optionValue: CancelEvent): void;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "show"): ShowEvent;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "show", optionValue: ShowEvent): void;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "hide"): HideEvent;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: "hide", optionValue: HideEvent): void;
	igLinkPropertiesDialog(options: IgLinkPropertiesDialog): JQuery;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: string): any;
	igLinkPropertiesDialog(optionLiteral: 'option', options: IgLinkPropertiesDialog): JQuery;
	igLinkPropertiesDialog(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igLinkPropertiesDialog(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igTablePropertiesDialog(methodName: "show", item: Object): void;
	igTablePropertiesDialog(methodName: "hide"): void;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "item"): any;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "item", optionValue: any): void;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "target"): any;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "target", optionValue: any): void;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "isHidden"): boolean;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "isHidden", optionValue: boolean): void;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "apply"): ApplyEvent;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "apply", optionValue: ApplyEvent): void;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "cancel"): CancelEvent;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "cancel", optionValue: CancelEvent): void;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "show"): ShowEvent;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "show", optionValue: ShowEvent): void;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "hide"): HideEvent;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: "hide", optionValue: HideEvent): void;
	igTablePropertiesDialog(options: IgTablePropertiesDialog): JQuery;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: string): any;
	igTablePropertiesDialog(optionLiteral: 'option', options: IgTablePropertiesDialog): JQuery;
	igTablePropertiesDialog(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTablePropertiesDialog(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igImagePropertiesDialog(methodName: "show", item: Object): void;
	igImagePropertiesDialog(methodName: "hide"): void;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "item"): any;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "item", optionValue: any): void;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "target"): any;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "target", optionValue: any): void;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "isHidden"): boolean;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "isHidden", optionValue: boolean): void;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "apply"): ApplyEvent;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "apply", optionValue: ApplyEvent): void;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "cancel"): CancelEvent;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "cancel", optionValue: CancelEvent): void;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "show"): ShowEvent;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "show", optionValue: ShowEvent): void;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "hide"): HideEvent;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: "hide", optionValue: HideEvent): void;
	igImagePropertiesDialog(options: IgImagePropertiesDialog): JQuery;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: string): any;
	igImagePropertiesDialog(optionLiteral: 'option', options: IgImagePropertiesDialog): JQuery;
	igImagePropertiesDialog(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igImagePropertiesDialog(methodName: string, ...methodParams: any[]): any;
}
interface IgLayoutManagerGridLayout {
	cols?: number;
	rows?: number;
	columnWidth?: any;
	columnHeight?: any;
	marginLeft?: number;
	marginTop?: number;
	rearrangeItems?: boolean;
	overrideConfigOnSetOption?: boolean;
	animationDuration?: number;
}

interface IgLayoutManagerBorderLayout {
	showHeader?: boolean;
	showFooter?: boolean;
	showLeft?: boolean;
	showRight?: boolean;
	leftWidth?: string;
	rightWidth?: string;
}

interface IgLayoutManagerItem {
	rowSpan?: number;
	colSpan?: number;
	colIndex?: number;
	rowIndex?: number;
	width?: string;
	height?: string;
}

interface ItemRenderingEvent {
	(event: Event, ui: ItemRenderingEventUIParam): void;
}

interface ItemRenderingEventUIParam {
	owner?: any;
	itemData?: any;
	index?: any;
}

interface ItemRenderedEvent {
	(event: Event, ui: ItemRenderedEventUIParam): void;
}

interface ItemRenderedEventUIParam {
	owner?: any;
	itemData?: any;
	index?: any;
}

interface InternalResizingEvent {
	(event: Event, ui: InternalResizingEventUIParam): void;
}

interface InternalResizingEventUIParam {
	owner?: any;
}

interface InternalResizedEvent {
	(event: Event, ui: InternalResizedEventUIParam): void;
}

interface InternalResizedEventUIParam {
	owner?: any;
}

interface IgLayoutManager {
	layoutMode?: any;
	itemCount?: number;
	gridLayout?: IgLayoutManagerGridLayout;
	borderLayout?: IgLayoutManagerBorderLayout;
	items?: IgLayoutManagerItem[];
	width?: string;
	height?: string;
	itemRendering?: ItemRenderingEvent;
	itemRendered?: ItemRenderedEvent;
	rendered?: RenderedEvent;
	internalResizing?: InternalResizingEvent;
	internalResized?: InternalResizedEvent;
}
interface IgLayoutManagerMethods {
	reflow(forceReflow?: Object, animationDuration?: number, event?: Object): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igLayoutManager"):IgLayoutManagerMethods;
}

interface JQuery {
	igLayoutManager(methodName: "reflow", forceReflow?: Object, animationDuration?: number, event?: Object): void;
	igLayoutManager(methodName: "destroy"): void;
	igLayoutManager(optionLiteral: 'option', optionName: "layoutMode"): any;
	igLayoutManager(optionLiteral: 'option', optionName: "layoutMode", optionValue: any): void;
	igLayoutManager(optionLiteral: 'option', optionName: "itemCount"): number;
	igLayoutManager(optionLiteral: 'option', optionName: "itemCount", optionValue: number): void;
	igLayoutManager(optionLiteral: 'option', optionName: "gridLayout"): IgLayoutManagerGridLayout;
	igLayoutManager(optionLiteral: 'option', optionName: "gridLayout", optionValue: IgLayoutManagerGridLayout): void;
	igLayoutManager(optionLiteral: 'option', optionName: "borderLayout"): IgLayoutManagerBorderLayout;
	igLayoutManager(optionLiteral: 'option', optionName: "borderLayout", optionValue: IgLayoutManagerBorderLayout): void;
	igLayoutManager(optionLiteral: 'option', optionName: "items"): IgLayoutManagerItem[];
	igLayoutManager(optionLiteral: 'option', optionName: "items", optionValue: IgLayoutManagerItem[]): void;
	igLayoutManager(optionLiteral: 'option', optionName: "width"): string;
	igLayoutManager(optionLiteral: 'option', optionName: "width", optionValue: string): void;
	igLayoutManager(optionLiteral: 'option', optionName: "height"): string;
	igLayoutManager(optionLiteral: 'option', optionName: "height", optionValue: string): void;
	igLayoutManager(optionLiteral: 'option', optionName: "itemRendering"): ItemRenderingEvent;
	igLayoutManager(optionLiteral: 'option', optionName: "itemRendering", optionValue: ItemRenderingEvent): void;
	igLayoutManager(optionLiteral: 'option', optionName: "itemRendered"): ItemRenderedEvent;
	igLayoutManager(optionLiteral: 'option', optionName: "itemRendered", optionValue: ItemRenderedEvent): void;
	igLayoutManager(optionLiteral: 'option', optionName: "rendered"): RenderedEvent;
	igLayoutManager(optionLiteral: 'option', optionName: "rendered", optionValue: RenderedEvent): void;
	igLayoutManager(optionLiteral: 'option', optionName: "internalResizing"): InternalResizingEvent;
	igLayoutManager(optionLiteral: 'option', optionName: "internalResizing", optionValue: InternalResizingEvent): void;
	igLayoutManager(optionLiteral: 'option', optionName: "internalResized"): InternalResizedEvent;
	igLayoutManager(optionLiteral: 'option', optionName: "internalResized", optionValue: InternalResizedEvent): void;
	igLayoutManager(options: IgLayoutManager): JQuery;
	igLayoutManager(optionLiteral: 'option', optionName: string): any;
	igLayoutManager(optionLiteral: 'option', options: IgLayoutManager): JQuery;
	igLayoutManager(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igLayoutManager(methodName: string, ...methodParams: any[]): any;
}
interface IgLinearGaugeRange {
	name?: string;
	brush?: string;
	outline?: string;
	startValue?: number;
	endValue?: number;
	innerStartExtent?: number;
	innerEndExtent?: number;
	outerStartExtent?: number;
	outerEndExtent?: number;
	strokeThickness?: number;
}

interface IgLinearGauge {
	width?: any;
	height?: any;
	ranges?: IgLinearGaugeRange[];
	rangeToolTipTemplate?: string;
	needleToolTipTemplate?: string;
	orientation?: any;
	rangeBrushes?: any;
	rangeOutlines?: any;
	minimumValue?: number;
	maximumValue?: number;
	value?: number;
	needleShape?: any;
	needleName?: string;
	rangeInnerExtent?: number;
	scaleInnerExtent?: number;
	rangeOuterExtent?: number;
	scaleOuterExtent?: number;
	needleInnerExtent?: number;
	needleOuterExtent?: number;
	needleInnerBaseWidth?: number;
	needleOuterBaseWidth?: number;
	needleInnerPointWidth?: number;
	needleOuterPointWidth?: number;
	needleInnerPointExtent?: number;
	needleOuterPointExtent?: number;
	interval?: number;
	ticksPostInitial?: number;
	ticksPreTerminal?: number;
	labelInterval?: number;
	labelExtent?: number;
	labelsPostInitial?: number;
	labelsPreTerminal?: number;
	minorTickCount?: number;
	tickStartExtent?: number;
	tickEndExtent?: number;
	tickStrokeThickness?: number;
	tickBrush?: string;
	fontBrush?: string;
	needleBreadth?: number;
	needleBrush?: string;
	needleOutline?: string;
	needleStrokeThickness?: number;
	minorTickStartExtent?: number;
	minorTickEndExtent?: number;
	minorTickStrokeThickness?: number;
	minorTickBrush?: string;
	isScaleInverted?: boolean;
	backingBrush?: string;
	backingOutline?: string;
	backingStrokeThickness?: number;
	backingInnerExtent?: number;
	backingOuterExtent?: number;
	scaleStartExtent?: number;
	scaleEndExtent?: number;
	scaleBrush?: string;
	scaleOutline?: string;
	scaleStrokeThickness?: number;
	transitionDuration?: number;
	showToolTipTimeout?: number;
	showToolTip?: boolean;
	font?: string;
	formatLabel?: FormatLabelEvent;
	alignLabel?: AlignLabelEvent;
}
interface IgLinearGaugeMethods {
	getRangeNames(): string;
	addRange(value: Object): void;
	removeRange(value: Object): void;
	updateRange(value: Object): void;
	getValueForPoint(x: Object, y: Object): number;
	needleContainsPoint(x: number, y: number): void;
	exportVisualData(): Object;
	flush(): void;
	destroy(): void;
	styleUpdated(): void;
}
interface JQuery {
	data(propertyName: "igLinearGauge"):IgLinearGaugeMethods;
}

interface JQuery {
	igLinearGauge(methodName: "getRangeNames"): string;
	igLinearGauge(methodName: "addRange", value: Object): void;
	igLinearGauge(methodName: "removeRange", value: Object): void;
	igLinearGauge(methodName: "updateRange", value: Object): void;
	igLinearGauge(methodName: "getValueForPoint", x: Object, y: Object): number;
	igLinearGauge(methodName: "needleContainsPoint", x: number, y: number): void;
	igLinearGauge(methodName: "exportVisualData"): Object;
	igLinearGauge(methodName: "flush"): void;
	igLinearGauge(methodName: "destroy"): void;
	igLinearGauge(methodName: "styleUpdated"): void;
	igLinearGauge(optionLiteral: 'option', optionName: "width"): any;
	igLinearGauge(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igLinearGauge(optionLiteral: 'option', optionName: "height"): any;
	igLinearGauge(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igLinearGauge(optionLiteral: 'option', optionName: "ranges"): IgLinearGaugeRange[];
	igLinearGauge(optionLiteral: 'option', optionName: "ranges", optionValue: IgLinearGaugeRange[]): void;
	igLinearGauge(optionLiteral: 'option', optionName: "rangeToolTipTemplate"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "rangeToolTipTemplate", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleToolTipTemplate"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "needleToolTipTemplate", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "orientation"): any;
	igLinearGauge(optionLiteral: 'option', optionName: "orientation", optionValue: any): void;
	igLinearGauge(optionLiteral: 'option', optionName: "rangeBrushes"): any;
	igLinearGauge(optionLiteral: 'option', optionName: "rangeBrushes", optionValue: any): void;
	igLinearGauge(optionLiteral: 'option', optionName: "rangeOutlines"): any;
	igLinearGauge(optionLiteral: 'option', optionName: "rangeOutlines", optionValue: any): void;
	igLinearGauge(optionLiteral: 'option', optionName: "minimumValue"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "minimumValue", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "maximumValue"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "maximumValue", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "value"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "value", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleShape"): any;
	igLinearGauge(optionLiteral: 'option', optionName: "needleShape", optionValue: any): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleName"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "needleName", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "rangeInnerExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "rangeInnerExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleInnerExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleInnerExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "rangeOuterExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "rangeOuterExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleOuterExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleOuterExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleInnerExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "needleInnerExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleOuterExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "needleOuterExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleInnerBaseWidth"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "needleInnerBaseWidth", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleOuterBaseWidth"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "needleOuterBaseWidth", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleInnerPointWidth"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "needleInnerPointWidth", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleOuterPointWidth"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "needleOuterPointWidth", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleInnerPointExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "needleInnerPointExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleOuterPointExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "needleOuterPointExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "interval"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "interval", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "ticksPostInitial"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "ticksPostInitial", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "ticksPreTerminal"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "ticksPreTerminal", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "labelInterval"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "labelInterval", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "labelExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "labelExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "labelsPostInitial"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "labelsPostInitial", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "labelsPreTerminal"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "labelsPreTerminal", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "minorTickCount"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "minorTickCount", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "tickStartExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "tickStartExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "tickEndExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "tickEndExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "tickStrokeThickness"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "tickStrokeThickness", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "tickBrush"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "tickBrush", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "fontBrush"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "fontBrush", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleBreadth"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "needleBreadth", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleBrush"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "needleBrush", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleOutline"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "needleOutline", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "needleStrokeThickness"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "needleStrokeThickness", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "minorTickStartExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "minorTickStartExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "minorTickEndExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "minorTickEndExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "minorTickStrokeThickness"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "minorTickStrokeThickness", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "minorTickBrush"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "minorTickBrush", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "isScaleInverted"): boolean;
	igLinearGauge(optionLiteral: 'option', optionName: "isScaleInverted", optionValue: boolean): void;
	igLinearGauge(optionLiteral: 'option', optionName: "backingBrush"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "backingBrush", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "backingOutline"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "backingOutline", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "backingStrokeThickness"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "backingStrokeThickness", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "backingInnerExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "backingInnerExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "backingOuterExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "backingOuterExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleStartExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleStartExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleEndExtent"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleEndExtent", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleBrush"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleBrush", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleOutline"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleOutline", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleStrokeThickness"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "scaleStrokeThickness", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "transitionDuration"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "transitionDuration", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "showToolTipTimeout"): number;
	igLinearGauge(optionLiteral: 'option', optionName: "showToolTipTimeout", optionValue: number): void;
	igLinearGauge(optionLiteral: 'option', optionName: "showToolTip"): boolean;
	igLinearGauge(optionLiteral: 'option', optionName: "showToolTip", optionValue: boolean): void;
	igLinearGauge(optionLiteral: 'option', optionName: "font"): string;
	igLinearGauge(optionLiteral: 'option', optionName: "font", optionValue: string): void;
	igLinearGauge(optionLiteral: 'option', optionName: "formatLabel"): FormatLabelEvent;
	igLinearGauge(optionLiteral: 'option', optionName: "formatLabel", optionValue: FormatLabelEvent): void;
	igLinearGauge(optionLiteral: 'option', optionName: "alignLabel"): AlignLabelEvent;
	igLinearGauge(optionLiteral: 'option', optionName: "alignLabel", optionValue: AlignLabelEvent): void;
	igLinearGauge(options: IgLinearGauge): JQuery;
	igLinearGauge(optionLiteral: 'option', optionName: string): any;
	igLinearGauge(optionLiteral: 'option', options: IgLinearGauge): JQuery;
	igLinearGauge(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igLinearGauge(methodName: string, ...methodParams: any[]): any;
}
interface IgMapCrosshairPoint {
	x?: number;
	y?: number;
}

interface IgMapBackgroundContent {
	type?: any;
	key?: string;
	parameter?: string;
	tilePath?: string;
	imagerySet?: string;
	bingUrl?: string;
}

interface IgMapSeries {
	type?: any;
	name?: string;
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	remove?: boolean;
	showTooltip?: boolean;
	shapeDataSource?: string;
	databaseSource?: string;
	triangulationDataSource?: string;
	legendItemBadgeTemplate?: any;
	legendItemTemplate?: any;
	discreteLegendItemTemplate?: any;
	transitionDuration?: number;
	resolution?: number;
	title?: string;
	brush?: string;
	outline?: string;
	thickness?: number;
	trianglesSource?: any;
	triangleVertexMemberPath1?: string;
	triangleVertexMemberPath2?: string;
	triangleVertexMemberPath3?: string;
	colorScale?: any;
	colorMemberPath?: string;
	visibleFromScale?: number;
	longitudeMemberPath?: string;
	latitudeMemberPath?: string;
	markerType?: any;
	markerTemplate?: any;
	shapeMemberPath?: string;
	shapeStyleSelector?: any;
	shapeStyle?: any;
	markerBrush?: string;
	markerOutline?: string;
	markerCollisionAvoidance?: any;
	fillScale?: any;
	fillMemberPath?: string;
	trendLineType?: any;
	trendLineBrush?: string;
	trendLineThickness?: number;
	trendLinePeriod?: number;
	trendLineZIndex?: number;
	maximumMarkers?: number;
	radiusMemberPath?: string;
	radiusScale?: any;
	labelMemberPath?: string;
	clipSeriesToBounds?: boolean;
	valueMemberPath?: string;
	unknownValuePlotting?: any;
	angleMemberPath?: number;
	useCartesianInterpolation?: boolean;
	stiffness?: number;
	negativeBrush?: string;
	splineType?: any;
	lowMemberPath?: string;
	highMemberPath?: string;
	openMemberPath?: string;
	closeMemberPath?: string;
	volumeMemberPath?: string;
	ignoreFirst?: number;
	period?: number;
	shortPeriod?: number;
	longPeriod?: number;
	valueResolver?: any;
	shapeFilterResolution?: number;
	useBruteForce?: boolean;
	progressiveLoad?: boolean;
	mouseOverEnabled?: boolean;
	useSquareCutoffStyle?: boolean;
	heatMinimum?: number;
	heatMaximum?: number;
}

interface TriangulationStatusChangedEvent {
	(event: Event, ui: TriangulationStatusChangedEventUIParam): void;
}

interface TriangulationStatusChangedEventUIParam {
	map?: any;
	series?: any;
	currentStatus?: any;
}

interface IgMap {
	width?: any;
	height?: any;
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	autoMarginWidth?: number;
	autoMarginHeight?: number;
	crosshairVisibility?: any;
	crosshairPoint?: IgMapCrosshairPoint;
	plotAreaBackground?: string;
	defaultInteraction?: any;
	dragModifier?: any;
	panModifier?: any;
	previewRect?: any;
	windowRect?: any;
	zoomable?: boolean;
	windowScale?: number;
	windowResponse?: any;
	windowRectMinWidth?: number;
	windowPositionHorizontal?: number;
	windowPositionVertical?: number;
	circleMarkerTemplate?: any;
	triangleMarkerTemplate?: any;
	pyramidMarkerTemplate?: any;
	squareMarkerTemplate?: any;
	diamondMarkerTemplate?: any;
	pentagonMarkerTemplate?: any;
	hexagonMarkerTemplate?: any;
	tetragramMarkerTemplate?: any;
	pentagramMarkerTemplate?: any;
	hexagramMarkerTemplate?: any;
	overviewPlusDetailPaneBackgroundImageUri?: string;
	useTiledZooming?: boolean;
	preferHigherResolutionTiles?: boolean;
	zoomTileCacheSize?: number;
	backgroundContent?: IgMapBackgroundContent;
	series?: IgMapSeries[];
	theme?: string;
	tooltipShowing?: TooltipShowingEvent;
	tooltipShown?: TooltipShownEvent;
	tooltipHiding?: TooltipHidingEvent;
	tooltipHidden?: TooltipHiddenEvent;
	browserNotSupported?: BrowserNotSupportedEvent;
	seriesCursorMouseMove?: SeriesCursorMouseMoveEvent;
	seriesMouseLeftButtonDown?: SeriesMouseLeftButtonDownEvent;
	seriesMouseLeftButtonUp?: SeriesMouseLeftButtonUpEvent;
	seriesMouseMove?: SeriesMouseMoveEvent;
	seriesMouseEnter?: SeriesMouseEnterEvent;
	seriesMouseLeave?: SeriesMouseLeaveEvent;
	windowRectChanged?: WindowRectChangedEvent;
	gridAreaRectChanged?: GridAreaRectChangedEvent;
	refreshCompleted?: RefreshCompletedEvent;
	triangulationStatusChanged?: TriangulationStatusChangedEvent;
}
interface IgMapMethods {
	option(): void;
	destroy(): void;
	id(): string;
	exportImage(width?: Object, height?: Object): Object;
	styleUpdated(): Object;
	resetZoom(): Object;
	addItem(item: Object, targetName: string): void;
	insertItem(item: Object, index: number, targetName: string): void;
	removeItem(index: number, targetName: string): void;
	setItem(index: number, item: Object, targetName: string): void;
	notifySetItem(dataSource: Object, index: number, newItem: Object, oldItem: Object): Object;
	notifyClearItems(dataSource: Object): Object;
	notifyInsertItem(dataSource: Object, index: number, newItem: Object): Object;
	notifyRemoveItem(dataSource: Object, index: number, oldItem: Object): Object;
	scrollIntoView(targetName: string, item: Object): Object;
	scaleValue(targetName: string, unscaledValue: number): number;
	unscaleValue(targetName: string, scaledValue: number): number;
	startTiledZoomingIfNecessary(): void;
	endTiledZoomingIfRunning(): void;
	clearTileZoomCache(): void;
	flush(): void;
	exportVisualData(): void;
	getActualMinimumValue(targetName: Object): void;
	getActualMaximumValue(targetName: Object): void;
	notifyContainerResized(): void;
	zoomToGeographic(rect: Object): Object;
	getGeographicFromZoom(rect: Object): Object;
	getZoomFromGeographic(rect: Object): Object;
	print(): void;
	renderSeries(targetName: string, animate: boolean): void;
}
interface JQuery {
	data(propertyName: "igMap"):IgMapMethods;
}

interface ShapeDataSourceSettings {
	id?: string;
	shapefileSource?: string;
	databaseSource?: string;
	callback?: Function;
	callee?: any;
	transformRecord?: Function;
	transformPoint?: Function;
	transformBounds?: Function;
	importCompleted?: Function;
}

declare module Infragistics {
export class ShapeDataSource  {
	constructor(settings: ShapeDataSourceSettings);
}
}
interface IgniteUIStatic {
ShapeDataSource(settings: ShapeDataSourceSettings): void;
}

interface TriangulationDataSourceSettings {
	id?: string;
	source?: string;
	triangulationSource?: string;
	callback?: Function;
	callee?: any;
}

declare module Infragistics {
export class TriangulationDataSource  {
	constructor(settings: TriangulationDataSourceSettings);
}
}
interface IgniteUIStatic {
TriangulationDataSource(settings: TriangulationDataSourceSettings): void;
}

interface JQuery {
	igMap(methodName: "option"): void;
	igMap(methodName: "destroy"): void;
	igMap(methodName: "id"): string;
	igMap(methodName: "exportImage", width?: Object, height?: Object): Object;
	igMap(methodName: "styleUpdated"): Object;
	igMap(methodName: "resetZoom"): Object;
	igMap(methodName: "addItem", item: Object, targetName: string): void;
	igMap(methodName: "insertItem", item: Object, index: number, targetName: string): void;
	igMap(methodName: "removeItem", index: number, targetName: string): void;
	igMap(methodName: "setItem", index: number, item: Object, targetName: string): void;
	igMap(methodName: "notifySetItem", dataSource: Object, index: number, newItem: Object, oldItem: Object): Object;
	igMap(methodName: "notifyClearItems", dataSource: Object): Object;
	igMap(methodName: "notifyInsertItem", dataSource: Object, index: number, newItem: Object): Object;
	igMap(methodName: "notifyRemoveItem", dataSource: Object, index: number, oldItem: Object): Object;
	igMap(methodName: "scrollIntoView", targetName: string, item: Object): Object;
	igMap(methodName: "scaleValue", targetName: string, unscaledValue: number): number;
	igMap(methodName: "unscaleValue", targetName: string, scaledValue: number): number;
	igMap(methodName: "startTiledZoomingIfNecessary"): void;
	igMap(methodName: "endTiledZoomingIfRunning"): void;
	igMap(methodName: "clearTileZoomCache"): void;
	igMap(methodName: "flush"): void;
	igMap(methodName: "exportVisualData"): void;
	igMap(methodName: "getActualMinimumValue", targetName: Object): void;
	igMap(methodName: "getActualMaximumValue", targetName: Object): void;
	igMap(methodName: "notifyContainerResized"): void;
	igMap(methodName: "zoomToGeographic", rect: Object): Object;
	igMap(methodName: "getGeographicFromZoom", rect: Object): Object;
	igMap(methodName: "getZoomFromGeographic", rect: Object): Object;
	igMap(methodName: "print"): void;
	igMap(methodName: "renderSeries", targetName: string, animate: boolean): void;
	igMap(optionLiteral: 'option', optionName: "width"): any;
	igMap(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "height"): any;
	igMap(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "dataSource"): any;
	igMap(optionLiteral: 'option', optionName: "dataSource", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "dataSourceUrl"): string;
	igMap(optionLiteral: 'option', optionName: "dataSourceUrl", optionValue: string): void;
	igMap(optionLiteral: 'option', optionName: "dataSourceType"): string;
	igMap(optionLiteral: 'option', optionName: "dataSourceType", optionValue: string): void;
	igMap(optionLiteral: 'option', optionName: "responseDataKey"): string;
	igMap(optionLiteral: 'option', optionName: "responseDataKey", optionValue: string): void;
	igMap(optionLiteral: 'option', optionName: "autoMarginWidth"): number;
	igMap(optionLiteral: 'option', optionName: "autoMarginWidth", optionValue: number): void;
	igMap(optionLiteral: 'option', optionName: "autoMarginHeight"): number;
	igMap(optionLiteral: 'option', optionName: "autoMarginHeight", optionValue: number): void;
	igMap(optionLiteral: 'option', optionName: "crosshairVisibility"): any;
	igMap(optionLiteral: 'option', optionName: "crosshairVisibility", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "crosshairPoint"): IgMapCrosshairPoint;
	igMap(optionLiteral: 'option', optionName: "crosshairPoint", optionValue: IgMapCrosshairPoint): void;
	igMap(optionLiteral: 'option', optionName: "plotAreaBackground"): string;
	igMap(optionLiteral: 'option', optionName: "plotAreaBackground", optionValue: string): void;
	igMap(optionLiteral: 'option', optionName: "defaultInteraction"): any;
	igMap(optionLiteral: 'option', optionName: "defaultInteraction", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "dragModifier"): any;
	igMap(optionLiteral: 'option', optionName: "dragModifier", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "panModifier"): any;
	igMap(optionLiteral: 'option', optionName: "panModifier", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "previewRect"): any;
	igMap(optionLiteral: 'option', optionName: "previewRect", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "windowRect"): any;
	igMap(optionLiteral: 'option', optionName: "windowRect", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "zoomable"): boolean;
	igMap(optionLiteral: 'option', optionName: "zoomable", optionValue: boolean): void;
	igMap(optionLiteral: 'option', optionName: "windowScale"): number;
	igMap(optionLiteral: 'option', optionName: "windowScale", optionValue: number): void;
	igMap(optionLiteral: 'option', optionName: "windowResponse"): any;
	igMap(optionLiteral: 'option', optionName: "windowResponse", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "windowRectMinWidth"): number;
	igMap(optionLiteral: 'option', optionName: "windowRectMinWidth", optionValue: number): void;
	igMap(optionLiteral: 'option', optionName: "windowPositionHorizontal"): number;
	igMap(optionLiteral: 'option', optionName: "windowPositionHorizontal", optionValue: number): void;
	igMap(optionLiteral: 'option', optionName: "windowPositionVertical"): number;
	igMap(optionLiteral: 'option', optionName: "windowPositionVertical", optionValue: number): void;
	igMap(optionLiteral: 'option', optionName: "circleMarkerTemplate"): any;
	igMap(optionLiteral: 'option', optionName: "circleMarkerTemplate", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "triangleMarkerTemplate"): any;
	igMap(optionLiteral: 'option', optionName: "triangleMarkerTemplate", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "pyramidMarkerTemplate"): any;
	igMap(optionLiteral: 'option', optionName: "pyramidMarkerTemplate", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "squareMarkerTemplate"): any;
	igMap(optionLiteral: 'option', optionName: "squareMarkerTemplate", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "diamondMarkerTemplate"): any;
	igMap(optionLiteral: 'option', optionName: "diamondMarkerTemplate", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "pentagonMarkerTemplate"): any;
	igMap(optionLiteral: 'option', optionName: "pentagonMarkerTemplate", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "hexagonMarkerTemplate"): any;
	igMap(optionLiteral: 'option', optionName: "hexagonMarkerTemplate", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "tetragramMarkerTemplate"): any;
	igMap(optionLiteral: 'option', optionName: "tetragramMarkerTemplate", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "pentagramMarkerTemplate"): any;
	igMap(optionLiteral: 'option', optionName: "pentagramMarkerTemplate", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "hexagramMarkerTemplate"): any;
	igMap(optionLiteral: 'option', optionName: "hexagramMarkerTemplate", optionValue: any): void;
	igMap(optionLiteral: 'option', optionName: "overviewPlusDetailPaneBackgroundImageUri"): string;
	igMap(optionLiteral: 'option', optionName: "overviewPlusDetailPaneBackgroundImageUri", optionValue: string): void;
	igMap(optionLiteral: 'option', optionName: "useTiledZooming"): boolean;
	igMap(optionLiteral: 'option', optionName: "useTiledZooming", optionValue: boolean): void;
	igMap(optionLiteral: 'option', optionName: "preferHigherResolutionTiles"): boolean;
	igMap(optionLiteral: 'option', optionName: "preferHigherResolutionTiles", optionValue: boolean): void;
	igMap(optionLiteral: 'option', optionName: "zoomTileCacheSize"): number;
	igMap(optionLiteral: 'option', optionName: "zoomTileCacheSize", optionValue: number): void;
	igMap(optionLiteral: 'option', optionName: "backgroundContent"): IgMapBackgroundContent;
	igMap(optionLiteral: 'option', optionName: "backgroundContent", optionValue: IgMapBackgroundContent): void;
	igMap(optionLiteral: 'option', optionName: "series"): IgMapSeries[];
	igMap(optionLiteral: 'option', optionName: "series", optionValue: IgMapSeries[]): void;
	igMap(optionLiteral: 'option', optionName: "theme"): string;
	igMap(optionLiteral: 'option', optionName: "theme", optionValue: string): void;
	igMap(optionLiteral: 'option', optionName: "tooltipShowing"): TooltipShowingEvent;
	igMap(optionLiteral: 'option', optionName: "tooltipShowing", optionValue: TooltipShowingEvent): void;
	igMap(optionLiteral: 'option', optionName: "tooltipShown"): TooltipShownEvent;
	igMap(optionLiteral: 'option', optionName: "tooltipShown", optionValue: TooltipShownEvent): void;
	igMap(optionLiteral: 'option', optionName: "tooltipHiding"): TooltipHidingEvent;
	igMap(optionLiteral: 'option', optionName: "tooltipHiding", optionValue: TooltipHidingEvent): void;
	igMap(optionLiteral: 'option', optionName: "tooltipHidden"): TooltipHiddenEvent;
	igMap(optionLiteral: 'option', optionName: "tooltipHidden", optionValue: TooltipHiddenEvent): void;
	igMap(optionLiteral: 'option', optionName: "browserNotSupported"): BrowserNotSupportedEvent;
	igMap(optionLiteral: 'option', optionName: "browserNotSupported", optionValue: BrowserNotSupportedEvent): void;
	igMap(optionLiteral: 'option', optionName: "seriesCursorMouseMove"): SeriesCursorMouseMoveEvent;
	igMap(optionLiteral: 'option', optionName: "seriesCursorMouseMove", optionValue: SeriesCursorMouseMoveEvent): void;
	igMap(optionLiteral: 'option', optionName: "seriesMouseLeftButtonDown"): SeriesMouseLeftButtonDownEvent;
	igMap(optionLiteral: 'option', optionName: "seriesMouseLeftButtonDown", optionValue: SeriesMouseLeftButtonDownEvent): void;
	igMap(optionLiteral: 'option', optionName: "seriesMouseLeftButtonUp"): SeriesMouseLeftButtonUpEvent;
	igMap(optionLiteral: 'option', optionName: "seriesMouseLeftButtonUp", optionValue: SeriesMouseLeftButtonUpEvent): void;
	igMap(optionLiteral: 'option', optionName: "seriesMouseMove"): SeriesMouseMoveEvent;
	igMap(optionLiteral: 'option', optionName: "seriesMouseMove", optionValue: SeriesMouseMoveEvent): void;
	igMap(optionLiteral: 'option', optionName: "seriesMouseEnter"): SeriesMouseEnterEvent;
	igMap(optionLiteral: 'option', optionName: "seriesMouseEnter", optionValue: SeriesMouseEnterEvent): void;
	igMap(optionLiteral: 'option', optionName: "seriesMouseLeave"): SeriesMouseLeaveEvent;
	igMap(optionLiteral: 'option', optionName: "seriesMouseLeave", optionValue: SeriesMouseLeaveEvent): void;
	igMap(optionLiteral: 'option', optionName: "windowRectChanged"): WindowRectChangedEvent;
	igMap(optionLiteral: 'option', optionName: "windowRectChanged", optionValue: WindowRectChangedEvent): void;
	igMap(optionLiteral: 'option', optionName: "gridAreaRectChanged"): GridAreaRectChangedEvent;
	igMap(optionLiteral: 'option', optionName: "gridAreaRectChanged", optionValue: GridAreaRectChangedEvent): void;
	igMap(optionLiteral: 'option', optionName: "refreshCompleted"): RefreshCompletedEvent;
	igMap(optionLiteral: 'option', optionName: "refreshCompleted", optionValue: RefreshCompletedEvent): void;
	igMap(optionLiteral: 'option', optionName: "triangulationStatusChanged"): TriangulationStatusChangedEvent;
	igMap(optionLiteral: 'option', optionName: "triangulationStatusChanged", optionValue: TriangulationStatusChangedEvent): void;
	igMap(options: IgMap): JQuery;
	igMap(optionLiteral: 'option', optionName: string): any;
	igMap(optionLiteral: 'option', options: IgMap): JQuery;
	igMap(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igMap(methodName: string, ...methodParams: any[]): any;
}
interface IgPivotDataSelectorDataSourceOptionsXmlaOptionsRequestOptions {
	withCredentials?: boolean;
	beforeSend?: Function;
}

interface IgPivotDataSelectorDataSourceOptionsXmlaOptionsMdxSettings {
	nonEmptyOnRows?: boolean;
	nonEmptyOnColumns?: boolean;
	addCalculatedMembersOnRows?: boolean;
	addCalculatedMembersOnColumns?: boolean;
	dimensionPropertiesOnRows?: any[];
	dimensionPropertiesOnColumns?: any[];
}

interface IgPivotDataSelectorDataSourceOptionsXmlaOptions {
	serverUrl?: string;
	catalog?: string;
	cube?: string;
	measureGroup?: string;
	requestOptions?: IgPivotDataSelectorDataSourceOptionsXmlaOptionsRequestOptions;
	enableResultCache?: boolean;
	discoverProperties?: any;
	executeProperties?: any;
	mdxSettings?: IgPivotDataSelectorDataSourceOptionsXmlaOptionsMdxSettings;
}

interface IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimensionMeasure {
	name?: string;
	caption?: string;
	aggregator?: Function;
	displayFolder?: string;
}

interface IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimension {
	name?: string;
	caption?: string;
	measures?: IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimensionMeasure[];
}

interface IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchieLevel {
	name?: string;
	caption?: string;
	memberProvider?: Function;
}

interface IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchie {
	name?: string;
	caption?: string;
	displayFolder?: string;
	levels?: IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchieLevel[];
}

interface IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCubeDimension {
	name?: string;
	caption?: string;
	hierarchies?: IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchie[];
}

interface IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCube {
	name?: string;
	caption?: string;
	measuresDimension?: IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimension;
	dimensions?: IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCubeDimension[];
}

interface IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadata {
	cube?: IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadataCube;
}

interface IgPivotDataSelectorDataSourceOptionsFlatDataOptions {
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	responseDataType?: string;
	metadata?: IgPivotDataSelectorDataSourceOptionsFlatDataOptionsMetadata;
}

interface IgPivotDataSelectorDataSourceOptions {
	xmlaOptions?: IgPivotDataSelectorDataSourceOptionsXmlaOptions;
	flatDataOptions?: IgPivotDataSelectorDataSourceOptionsFlatDataOptions;
	measures?: string;
	filters?: string;
	rows?: string;
	columns?: string;
}

interface IgPivotDataSelectorDragAndDropSettings {
	appendTo?: any;
	containment?: any;
	zIndex?: number;
}

interface DataSelectorRenderedEvent {
	(event: Event, ui: DataSelectorRenderedEventUIParam): void;
}

interface DataSelectorRenderedEventUIParam {
	owner?: any;
}

interface DataSourceInitializedEvent {
	(event: Event, ui: DataSourceInitializedEventUIParam): void;
}

interface DataSourceInitializedEventUIParam {
	owner?: any;
	dataSource?: any;
	error?: any;
	metadataTreeRoot?: any;
}

interface DataSourceUpdatedEvent {
	(event: Event, ui: DataSourceUpdatedEventUIParam): void;
}

interface DataSourceUpdatedEventUIParam {
	owner?: any;
	dataSource?: any;
	error?: any;
	result?: any;
}

interface DeferUpdateChangedEvent {
	(event: Event, ui: DeferUpdateChangedEventUIParam): void;
}

interface DeferUpdateChangedEventUIParam {
	owner?: any;
	deferUpdate?: any;
}

interface DragStartEvent {
	(event: Event, ui: DragStartEventUIParam): void;
}

interface DragStartEventUIParam {
	metadata?: any;
	helper?: any;
	offset?: any;
	originalPosition?: any;
	position?: any;
}

interface DragEvent {
	(event: Event, ui: DragEventUIParam): void;
}

interface DragEventUIParam {
	metadata?: any;
	helper?: any;
	offset?: any;
	originalPosition?: any;
	position?: any;
}

interface DragStopEvent {
	(event: Event, ui: DragStopEventUIParam): void;
}

interface DragStopEventUIParam {
	helper?: any;
	offset?: any;
	originalPosition?: any;
	position?: any;
}

interface MetadataDroppingEvent {
	(event: Event, ui: MetadataDroppingEventUIParam): void;
}

interface MetadataDroppingEventUIParam {
	targetElement?: any;
	draggedElement?: any;
	metadata?: any;
	metadataIndex?: any;
	helper?: any;
	offset?: any;
	position?: any;
}

interface MetadataDroppedEvent {
	(event: Event, ui: MetadataDroppedEventUIParam): void;
}

interface MetadataDroppedEventUIParam {
	targetElement?: any;
	draggedElement?: any;
	metadata?: any;
	metadataIndex?: any;
	helper?: any;
	offset?: any;
	position?: any;
}

interface MetadataRemovingEvent {
	(event: Event, ui: MetadataRemovingEventUIParam): void;
}

interface MetadataRemovingEventUIParam {
	targetElement?: any;
	metadata?: any;
}

interface MetadataRemovedEvent {
	(event: Event, ui: MetadataRemovedEventUIParam): void;
}

interface MetadataRemovedEventUIParam {
	metadata?: any;
}

interface FilterDropDownOpeningEvent {
	(event: Event, ui: FilterDropDownOpeningEventUIParam): void;
}

interface FilterDropDownOpeningEventUIParam {
	hierarchy?: any;
}

interface FilterDropDownOpenedEvent {
	(event: Event, ui: FilterDropDownOpenedEventUIParam): void;
}

interface FilterDropDownOpenedEventUIParam {
	hierarchy?: any;
	dropDownElement?: any;
}

interface FilterMembersLoadedEvent {
	(event: Event, ui: FilterMembersLoadedEventUIParam): void;
}

interface FilterMembersLoadedEventUIParam {
	parent?: any;
	rootFilterMembers?: any;
	filterMembers?: any;
}

interface FilterDropDownOkEvent {
	(event: Event, ui: FilterDropDownOkEventUIParam): void;
}

interface FilterDropDownOkEventUIParam {
	hierarchy?: any;
	filterMembers?: any;
	dropDownElement?: any;
}

interface FilterDropDownClosingEvent {
	(event: Event, ui: FilterDropDownClosingEventUIParam): void;
}

interface FilterDropDownClosingEventUIParam {
	hierarchy?: any;
	dropDownElement?: any;
}

interface FilterDropDownClosedEvent {
	(event: Event, ui: FilterDropDownClosedEventUIParam): void;
}

interface FilterDropDownClosedEventUIParam {
	hierarchy?: any;
}

interface IgPivotDataSelector {
	width?: any;
	height?: any;
	dataSource?: any;
	dataSourceOptions?: IgPivotDataSelectorDataSourceOptions;
	deferUpdate?: boolean;
	dragAndDropSettings?: IgPivotDataSelectorDragAndDropSettings;
	dropDownParent?: any;
	disableRowsDropArea?: boolean;
	disableColumnsDropArea?: boolean;
	disableMeasuresDropArea?: boolean;
	disableFiltersDropArea?: boolean;
	customMoveValidation?: Function;
	dataSelectorRendered?: DataSelectorRenderedEvent;
	dataSourceInitialized?: DataSourceInitializedEvent;
	dataSourceUpdated?: DataSourceUpdatedEvent;
	deferUpdateChanged?: DeferUpdateChangedEvent;
	dragStart?: DragStartEvent;
	drag?: DragEvent;
	dragStop?: DragStopEvent;
	metadataDropping?: MetadataDroppingEvent;
	metadataDropped?: MetadataDroppedEvent;
	metadataRemoving?: MetadataRemovingEvent;
	metadataRemoved?: MetadataRemovedEvent;
	filterDropDownOpening?: FilterDropDownOpeningEvent;
	filterDropDownOpened?: FilterDropDownOpenedEvent;
	filterMembersLoaded?: FilterMembersLoadedEvent;
	filterDropDownOk?: FilterDropDownOkEvent;
	filterDropDownClosing?: FilterDropDownClosingEvent;
	filterDropDownClosed?: FilterDropDownClosedEvent;
}
interface IgPivotDataSelectorMethods {
	update(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igPivotDataSelector"):IgPivotDataSelectorMethods;
}

interface JQuery {
	igPivotDataSelector(methodName: "update"): void;
	igPivotDataSelector(methodName: "destroy"): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "width"): any;
	igPivotDataSelector(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "height"): any;
	igPivotDataSelector(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dataSource"): any;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dataSource", optionValue: any): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dataSourceOptions"): IgPivotDataSelectorDataSourceOptions;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dataSourceOptions", optionValue: IgPivotDataSelectorDataSourceOptions): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "deferUpdate"): boolean;
	igPivotDataSelector(optionLiteral: 'option', optionName: "deferUpdate", optionValue: boolean): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dragAndDropSettings"): IgPivotDataSelectorDragAndDropSettings;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dragAndDropSettings", optionValue: IgPivotDataSelectorDragAndDropSettings): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dropDownParent"): any;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dropDownParent", optionValue: any): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "disableRowsDropArea"): boolean;
	igPivotDataSelector(optionLiteral: 'option', optionName: "disableRowsDropArea", optionValue: boolean): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "disableColumnsDropArea"): boolean;
	igPivotDataSelector(optionLiteral: 'option', optionName: "disableColumnsDropArea", optionValue: boolean): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "disableMeasuresDropArea"): boolean;
	igPivotDataSelector(optionLiteral: 'option', optionName: "disableMeasuresDropArea", optionValue: boolean): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "disableFiltersDropArea"): boolean;
	igPivotDataSelector(optionLiteral: 'option', optionName: "disableFiltersDropArea", optionValue: boolean): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "customMoveValidation"): Function;
	igPivotDataSelector(optionLiteral: 'option', optionName: "customMoveValidation", optionValue: Function): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dataSelectorRendered"): DataSelectorRenderedEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dataSelectorRendered", optionValue: DataSelectorRenderedEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dataSourceInitialized"): DataSourceInitializedEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dataSourceInitialized", optionValue: DataSourceInitializedEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dataSourceUpdated"): DataSourceUpdatedEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dataSourceUpdated", optionValue: DataSourceUpdatedEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "deferUpdateChanged"): DeferUpdateChangedEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "deferUpdateChanged", optionValue: DeferUpdateChangedEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dragStart"): DragStartEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dragStart", optionValue: DragStartEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "drag"): DragEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "drag", optionValue: DragEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dragStop"): DragStopEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "dragStop", optionValue: DragStopEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "metadataDropping"): MetadataDroppingEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "metadataDropping", optionValue: MetadataDroppingEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "metadataDropped"): MetadataDroppedEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "metadataDropped", optionValue: MetadataDroppedEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "metadataRemoving"): MetadataRemovingEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "metadataRemoving", optionValue: MetadataRemovingEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "metadataRemoved"): MetadataRemovedEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "metadataRemoved", optionValue: MetadataRemovedEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterDropDownOpening"): FilterDropDownOpeningEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterDropDownOpening", optionValue: FilterDropDownOpeningEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterDropDownOpened"): FilterDropDownOpenedEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterDropDownOpened", optionValue: FilterDropDownOpenedEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterMembersLoaded"): FilterMembersLoadedEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterMembersLoaded", optionValue: FilterMembersLoadedEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterDropDownOk"): FilterDropDownOkEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterDropDownOk", optionValue: FilterDropDownOkEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterDropDownClosing"): FilterDropDownClosingEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterDropDownClosing", optionValue: FilterDropDownClosingEvent): void;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterDropDownClosed"): FilterDropDownClosedEvent;
	igPivotDataSelector(optionLiteral: 'option', optionName: "filterDropDownClosed", optionValue: FilterDropDownClosedEvent): void;
	igPivotDataSelector(options: IgPivotDataSelector): JQuery;
	igPivotDataSelector(optionLiteral: 'option', optionName: string): any;
	igPivotDataSelector(optionLiteral: 'option', options: IgPivotDataSelector): JQuery;
	igPivotDataSelector(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igPivotDataSelector(methodName: string, ...methodParams: any[]): any;
}
interface IgPivotGridDataSourceOptionsXmlaOptionsRequestOptions {
	withCredentials?: boolean;
	beforeSend?: Function;
}

interface IgPivotGridDataSourceOptionsXmlaOptionsMdxSettings {
	nonEmptyOnRows?: boolean;
	nonEmptyOnColumns?: boolean;
	addCalculatedMembersOnRows?: boolean;
	addCalculatedMembersOnColumns?: boolean;
	dimensionPropertiesOnRows?: any[];
	dimensionPropertiesOnColumns?: any[];
}

interface IgPivotGridDataSourceOptionsXmlaOptions {
	serverUrl?: string;
	catalog?: string;
	cube?: string;
	measureGroup?: string;
	requestOptions?: IgPivotGridDataSourceOptionsXmlaOptionsRequestOptions;
	enableResultCache?: boolean;
	discoverProperties?: any;
	executeProperties?: any;
	mdxSettings?: IgPivotGridDataSourceOptionsXmlaOptionsMdxSettings;
}

interface IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimensionMeasure {
	name?: string;
	caption?: string;
	aggregator?: Function;
	displayFolder?: string;
}

interface IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimension {
	name?: string;
	caption?: string;
	measures?: IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimensionMeasure[];
}

interface IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchieLevel {
	name?: string;
	caption?: string;
	memberProvider?: Function;
}

interface IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchie {
	name?: string;
	caption?: string;
	displayFolder?: string;
	levels?: IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchieLevel[];
}

interface IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCubeDimension {
	name?: string;
	caption?: string;
	hierarchies?: IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchie[];
}

interface IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCube {
	name?: string;
	caption?: string;
	measuresDimension?: IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimension;
	dimensions?: IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCubeDimension[];
}

interface IgPivotGridDataSourceOptionsFlatDataOptionsMetadata {
	cube?: IgPivotGridDataSourceOptionsFlatDataOptionsMetadataCube;
}

interface IgPivotGridDataSourceOptionsFlatDataOptions {
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	responseDataType?: string;
	metadata?: IgPivotGridDataSourceOptionsFlatDataOptionsMetadata;
}

interface IgPivotGridDataSourceOptions {
	xmlaOptions?: IgPivotGridDataSourceOptionsXmlaOptions;
	flatDataOptions?: IgPivotGridDataSourceOptionsFlatDataOptions;
	measures?: string;
	filters?: string;
	rows?: string;
	columns?: string;
}

interface IgPivotGridLevelSortDirection {
	levelUniqueName?: string;
	sortDirection?: any;
	sortBehavior?: any;
}

interface IgPivotGridGridOptionsFeatures {
}

interface IgPivotGridGridOptions {
	defaultColumnWidth?: any;
	fixedHeaders?: boolean;
	caption?: string;
	features?: IgPivotGridGridOptionsFeatures;
	tabIndex?: number;
	alternateRowStyles?: boolean;
	enableHoverStyles?: boolean;
}

interface IgPivotGridDragAndDropSettings {
	appendTo?: any;
	containment?: any;
	zIndex?: number;
}

interface PivotGridHeadersRenderedEvent {
	(event: Event, ui: PivotGridHeadersRenderedEventUIParam): void;
}

interface PivotGridHeadersRenderedEventUIParam {
	owner?: any;
	grid?: any;
	table?: any;
}

interface PivotGridRenderedEvent {
	(event: Event, ui: PivotGridRenderedEventUIParam): void;
}

interface PivotGridRenderedEventUIParam {
	owner?: any;
	grid?: any;
}

interface TupleMemberExpandingEvent {
	(event: Event, ui: TupleMemberExpandingEventUIParam): void;
}

interface TupleMemberExpandingEventUIParam {
	owner?: any;
	dataSource?: any;
	axisName?: any;
	tupleIndex?: any;
	memberIndex?: any;
}

interface TupleMemberExpandedEvent {
	(event: Event, ui: TupleMemberExpandedEventUIParam): void;
}

interface TupleMemberExpandedEventUIParam {
	owner?: any;
	dataSource?: any;
	axisName?: any;
	tupleIndex?: any;
	memberIndex?: any;
}

interface TupleMemberCollapsingEvent {
	(event: Event, ui: TupleMemberCollapsingEventUIParam): void;
}

interface TupleMemberCollapsingEventUIParam {
	owner?: any;
	dataSource?: any;
	axisName?: any;
	tupleIndex?: any;
	memberIndex?: any;
}

interface TupleMemberCollapsedEvent {
	(event: Event, ui: TupleMemberCollapsedEventUIParam): void;
}

interface TupleMemberCollapsedEventUIParam {
	owner?: any;
	dataSource?: any;
	axisName?: any;
	tupleIndex?: any;
	memberIndex?: any;
}

interface SortingEvent {
	(event: Event, ui: SortingEventUIParam): void;
}

interface SortingEventUIParam {
	owner?: any;
	sortDirections?: any;
}

interface SortedEvent {
	(event: Event, ui: SortedEventUIParam): void;
}

interface SortedEventUIParam {
	owner?: any;
	sortDirections?: any;
	appliedSortDirections?: any;
}

interface HeadersSortingEvent {
	(event: Event, ui: HeadersSortingEventUIParam): void;
}

interface HeadersSortingEventUIParam {
	owner?: any;
	levelSortDirections?: any;
}

interface HeadersSortedEvent {
	(event: Event, ui: HeadersSortedEventUIParam): void;
}

interface HeadersSortedEventUIParam {
	owner?: any;
	levelSortDirections?: any;
	appliedLevelSortDirections?: any;
}

interface IgPivotGrid {
	width?: any;
	height?: any;
	dataSource?: any;
	dataSourceOptions?: IgPivotGridDataSourceOptions;
	deferUpdate?: boolean;
	isParentInFrontForColumns?: boolean;
	isParentInFrontForRows?: boolean;
	compactColumnHeaders?: boolean;
	compactRowHeaders?: boolean;
	rowHeadersLayout?: any;
	compactColumnHeaderIndentation?: number;
	compactRowHeaderIndentation?: number;
	rowHeaderLinkGroupIndentation?: number;
	treeRowHeaderIndentation?: number;
	defaultRowHeaderWidth?: number;
	allowSorting?: boolean;
	firstSortDirection?: any;
	allowHeaderRowsSorting?: boolean;
	allowHeaderColumnsSorting?: boolean;
	levelSortDirections?: IgPivotGridLevelSortDirection[];
	defaultLevelSortBehavior?: any;
	firstLevelSortDirection?: any;
	gridOptions?: IgPivotGridGridOptions;
	dragAndDropSettings?: IgPivotGridDragAndDropSettings;
	dropDownParent?: any;
	disableRowsDropArea?: boolean;
	disableColumnsDropArea?: boolean;
	disableMeasuresDropArea?: boolean;
	disableFiltersDropArea?: boolean;
	hideRowsDropArea?: boolean;
	hideColumnsDropArea?: boolean;
	hideMeasuresDropArea?: boolean;
	hideFiltersDropArea?: boolean;
	customMoveValidation?: Function;
	dataSourceInitialized?: DataSourceInitializedEvent;
	dataSourceUpdated?: DataSourceUpdatedEvent;
	pivotGridHeadersRendered?: PivotGridHeadersRenderedEvent;
	pivotGridRendered?: PivotGridRenderedEvent;
	tupleMemberExpanding?: TupleMemberExpandingEvent;
	tupleMemberExpanded?: TupleMemberExpandedEvent;
	tupleMemberCollapsing?: TupleMemberCollapsingEvent;
	tupleMemberCollapsed?: TupleMemberCollapsedEvent;
	sorting?: SortingEvent;
	sorted?: SortedEvent;
	headersSorting?: HeadersSortingEvent;
	headersSorted?: HeadersSortedEvent;
	dragStart?: DragStartEvent;
	drag?: DragEvent;
	dragStop?: DragStopEvent;
	metadataDropping?: MetadataDroppingEvent;
	metadataDropped?: MetadataDroppedEvent;
	metadataRemoving?: MetadataRemovingEvent;
	metadataRemoved?: MetadataRemovedEvent;
	filterDropDownOpening?: FilterDropDownOpeningEvent;
	filterDropDownOpened?: FilterDropDownOpenedEvent;
	filterMembersLoaded?: FilterMembersLoadedEvent;
	filterDropDownOk?: FilterDropDownOkEvent;
	filterDropDownClosing?: FilterDropDownClosingEvent;
	filterDropDownClosed?: FilterDropDownClosedEvent;
}
interface IgPivotGridMethods {
	grid(): Object;
	updateGrid(): void;
	expandTupleMember(tupleLocation: string, tupleIndex: number, memberIndex: number, shouldUpdate?: boolean): boolean;
	collapseTupleMember(tupleLocation: string, tupleIndex: number, memberIndex: number, shouldUpdate?: boolean): boolean;
	appliedColumnSortDirections(): any[];
	appliedLevelSortDirections(): any[];
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igPivotGrid"):IgPivotGridMethods;
}

interface JQuery {
	igPivotGrid(methodName: "grid"): Object;
	igPivotGrid(methodName: "updateGrid"): void;
	igPivotGrid(methodName: "expandTupleMember", tupleLocation: string, tupleIndex: number, memberIndex: number, shouldUpdate?: boolean): boolean;
	igPivotGrid(methodName: "collapseTupleMember", tupleLocation: string, tupleIndex: number, memberIndex: number, shouldUpdate?: boolean): boolean;
	igPivotGrid(methodName: "appliedColumnSortDirections"): any[];
	igPivotGrid(methodName: "appliedLevelSortDirections"): any[];
	igPivotGrid(methodName: "destroy"): void;
	igPivotGrid(optionLiteral: 'option', optionName: "width"): any;
	igPivotGrid(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igPivotGrid(optionLiteral: 'option', optionName: "height"): any;
	igPivotGrid(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igPivotGrid(optionLiteral: 'option', optionName: "dataSource"): any;
	igPivotGrid(optionLiteral: 'option', optionName: "dataSource", optionValue: any): void;
	igPivotGrid(optionLiteral: 'option', optionName: "dataSourceOptions"): IgPivotGridDataSourceOptions;
	igPivotGrid(optionLiteral: 'option', optionName: "dataSourceOptions", optionValue: IgPivotGridDataSourceOptions): void;
	igPivotGrid(optionLiteral: 'option', optionName: "deferUpdate"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "deferUpdate", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "isParentInFrontForColumns"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "isParentInFrontForColumns", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "isParentInFrontForRows"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "isParentInFrontForRows", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "compactColumnHeaders"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "compactColumnHeaders", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "compactRowHeaders"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "compactRowHeaders", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "rowHeadersLayout"): any;
	igPivotGrid(optionLiteral: 'option', optionName: "rowHeadersLayout", optionValue: any): void;
	igPivotGrid(optionLiteral: 'option', optionName: "compactColumnHeaderIndentation"): number;
	igPivotGrid(optionLiteral: 'option', optionName: "compactColumnHeaderIndentation", optionValue: number): void;
	igPivotGrid(optionLiteral: 'option', optionName: "compactRowHeaderIndentation"): number;
	igPivotGrid(optionLiteral: 'option', optionName: "compactRowHeaderIndentation", optionValue: number): void;
	igPivotGrid(optionLiteral: 'option', optionName: "rowHeaderLinkGroupIndentation"): number;
	igPivotGrid(optionLiteral: 'option', optionName: "rowHeaderLinkGroupIndentation", optionValue: number): void;
	igPivotGrid(optionLiteral: 'option', optionName: "treeRowHeaderIndentation"): number;
	igPivotGrid(optionLiteral: 'option', optionName: "treeRowHeaderIndentation", optionValue: number): void;
	igPivotGrid(optionLiteral: 'option', optionName: "defaultRowHeaderWidth"): number;
	igPivotGrid(optionLiteral: 'option', optionName: "defaultRowHeaderWidth", optionValue: number): void;
	igPivotGrid(optionLiteral: 'option', optionName: "allowSorting"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "allowSorting", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "firstSortDirection"): any;
	igPivotGrid(optionLiteral: 'option', optionName: "firstSortDirection", optionValue: any): void;
	igPivotGrid(optionLiteral: 'option', optionName: "allowHeaderRowsSorting"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "allowHeaderRowsSorting", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "allowHeaderColumnsSorting"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "allowHeaderColumnsSorting", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "levelSortDirections"): IgPivotGridLevelSortDirection[];
	igPivotGrid(optionLiteral: 'option', optionName: "levelSortDirections", optionValue: IgPivotGridLevelSortDirection[]): void;
	igPivotGrid(optionLiteral: 'option', optionName: "defaultLevelSortBehavior"): any;
	igPivotGrid(optionLiteral: 'option', optionName: "defaultLevelSortBehavior", optionValue: any): void;
	igPivotGrid(optionLiteral: 'option', optionName: "firstLevelSortDirection"): any;
	igPivotGrid(optionLiteral: 'option', optionName: "firstLevelSortDirection", optionValue: any): void;
	igPivotGrid(optionLiteral: 'option', optionName: "gridOptions"): IgPivotGridGridOptions;
	igPivotGrid(optionLiteral: 'option', optionName: "gridOptions", optionValue: IgPivotGridGridOptions): void;
	igPivotGrid(optionLiteral: 'option', optionName: "dragAndDropSettings"): IgPivotGridDragAndDropSettings;
	igPivotGrid(optionLiteral: 'option', optionName: "dragAndDropSettings", optionValue: IgPivotGridDragAndDropSettings): void;
	igPivotGrid(optionLiteral: 'option', optionName: "dropDownParent"): any;
	igPivotGrid(optionLiteral: 'option', optionName: "dropDownParent", optionValue: any): void;
	igPivotGrid(optionLiteral: 'option', optionName: "disableRowsDropArea"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "disableRowsDropArea", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "disableColumnsDropArea"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "disableColumnsDropArea", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "disableMeasuresDropArea"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "disableMeasuresDropArea", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "disableFiltersDropArea"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "disableFiltersDropArea", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "hideRowsDropArea"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "hideRowsDropArea", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "hideColumnsDropArea"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "hideColumnsDropArea", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "hideMeasuresDropArea"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "hideMeasuresDropArea", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "hideFiltersDropArea"): boolean;
	igPivotGrid(optionLiteral: 'option', optionName: "hideFiltersDropArea", optionValue: boolean): void;
	igPivotGrid(optionLiteral: 'option', optionName: "customMoveValidation"): Function;
	igPivotGrid(optionLiteral: 'option', optionName: "customMoveValidation", optionValue: Function): void;
	igPivotGrid(optionLiteral: 'option', optionName: "dataSourceInitialized"): DataSourceInitializedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "dataSourceInitialized", optionValue: DataSourceInitializedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "dataSourceUpdated"): DataSourceUpdatedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "dataSourceUpdated", optionValue: DataSourceUpdatedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "pivotGridHeadersRendered"): PivotGridHeadersRenderedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "pivotGridHeadersRendered", optionValue: PivotGridHeadersRenderedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "pivotGridRendered"): PivotGridRenderedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "pivotGridRendered", optionValue: PivotGridRenderedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "tupleMemberExpanding"): TupleMemberExpandingEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "tupleMemberExpanding", optionValue: TupleMemberExpandingEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "tupleMemberExpanded"): TupleMemberExpandedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "tupleMemberExpanded", optionValue: TupleMemberExpandedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "tupleMemberCollapsing"): TupleMemberCollapsingEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "tupleMemberCollapsing", optionValue: TupleMemberCollapsingEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "tupleMemberCollapsed"): TupleMemberCollapsedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "tupleMemberCollapsed", optionValue: TupleMemberCollapsedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "sorting"): SortingEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "sorting", optionValue: SortingEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "sorted"): SortedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "sorted", optionValue: SortedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "headersSorting"): HeadersSortingEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "headersSorting", optionValue: HeadersSortingEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "headersSorted"): HeadersSortedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "headersSorted", optionValue: HeadersSortedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "dragStart"): DragStartEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "dragStart", optionValue: DragStartEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "drag"): DragEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "drag", optionValue: DragEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "dragStop"): DragStopEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "dragStop", optionValue: DragStopEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "metadataDropping"): MetadataDroppingEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "metadataDropping", optionValue: MetadataDroppingEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "metadataDropped"): MetadataDroppedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "metadataDropped", optionValue: MetadataDroppedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "metadataRemoving"): MetadataRemovingEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "metadataRemoving", optionValue: MetadataRemovingEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "metadataRemoved"): MetadataRemovedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "metadataRemoved", optionValue: MetadataRemovedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "filterDropDownOpening"): FilterDropDownOpeningEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "filterDropDownOpening", optionValue: FilterDropDownOpeningEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "filterDropDownOpened"): FilterDropDownOpenedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "filterDropDownOpened", optionValue: FilterDropDownOpenedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "filterMembersLoaded"): FilterMembersLoadedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "filterMembersLoaded", optionValue: FilterMembersLoadedEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "filterDropDownOk"): FilterDropDownOkEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "filterDropDownOk", optionValue: FilterDropDownOkEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "filterDropDownClosing"): FilterDropDownClosingEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "filterDropDownClosing", optionValue: FilterDropDownClosingEvent): void;
	igPivotGrid(optionLiteral: 'option', optionName: "filterDropDownClosed"): FilterDropDownClosedEvent;
	igPivotGrid(optionLiteral: 'option', optionName: "filterDropDownClosed", optionValue: FilterDropDownClosedEvent): void;
	igPivotGrid(options: IgPivotGrid): JQuery;
	igPivotGrid(optionLiteral: 'option', optionName: string): any;
	igPivotGrid(optionLiteral: 'option', options: IgPivotGrid): JQuery;
	igPivotGrid(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igPivotGrid(methodName: string, ...methodParams: any[]): any;
}
interface IgPivotViewDataSourceOptionsXmlaOptionsRequestOptions {
	withCredentials?: boolean;
	beforeSend?: Function;
}

interface IgPivotViewDataSourceOptionsXmlaOptionsMdxSettings {
	nonEmptyOnRows?: boolean;
	nonEmptyOnColumns?: boolean;
	addCalculatedMembersOnRows?: boolean;
	addCalculatedMembersOnColumns?: boolean;
	dimensionPropertiesOnRows?: any[];
	dimensionPropertiesOnColumns?: any[];
}

interface IgPivotViewDataSourceOptionsXmlaOptions {
	serverUrl?: string;
	catalog?: string;
	cube?: string;
	measureGroup?: string;
	requestOptions?: IgPivotViewDataSourceOptionsXmlaOptionsRequestOptions;
	enableResultCache?: boolean;
	discoverProperties?: any;
	executeProperties?: any;
	mdxSettings?: IgPivotViewDataSourceOptionsXmlaOptionsMdxSettings;
}

interface IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimensionMeasure {
	name?: string;
	caption?: string;
	aggregator?: Function;
	displayFolder?: string;
}

interface IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimension {
	name?: string;
	caption?: string;
	measures?: IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimensionMeasure[];
}

interface IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchieLevel {
	name?: string;
	caption?: string;
	memberProvider?: Function;
}

interface IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchie {
	name?: string;
	caption?: string;
	displayFolder?: string;
	levels?: IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchieLevel[];
}

interface IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCubeDimension {
	name?: string;
	caption?: string;
	hierarchies?: IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCubeDimensionHierarchie[];
}

interface IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCube {
	name?: string;
	caption?: string;
	measuresDimension?: IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCubeMeasuresDimension;
	dimensions?: IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCubeDimension[];
}

interface IgPivotViewDataSourceOptionsFlatDataOptionsMetadata {
	cube?: IgPivotViewDataSourceOptionsFlatDataOptionsMetadataCube;
}

interface IgPivotViewDataSourceOptionsFlatDataOptions {
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	responseDataType?: string;
	metadata?: IgPivotViewDataSourceOptionsFlatDataOptionsMetadata;
}

interface IgPivotViewDataSourceOptions {
	xmlaOptions?: IgPivotViewDataSourceOptionsXmlaOptions;
	flatDataOptions?: IgPivotViewDataSourceOptionsFlatDataOptions;
	measures?: string;
	filters?: string;
	rows?: string;
	columns?: string;
}

interface IgPivotViewPivotGridOptionsLevelSortDirection {
	levelUniqueName?: string;
	sortDirection?: any;
}

interface IgPivotViewPivotGridOptionsGridOptionsFeatures {
}

interface IgPivotViewPivotGridOptionsGridOptions {
	defaultColumnWidth?: any;
	fixedHeaders?: boolean;
	caption?: string;
	features?: IgPivotViewPivotGridOptionsGridOptionsFeatures;
	tabIndex?: number;
	alternateRowStyles?: boolean;
	enableHoverStyles?: boolean;
}

interface IgPivotViewPivotGridOptionsDragAndDropSettings {
	appendTo?: any;
	containment?: any;
	zIndex?: number;
}

interface IgPivotViewPivotGridOptions {
	isParentInFrontForColumns?: boolean;
	isParentInFrontForRows?: boolean;
	compactColumnHeaders?: boolean;
	rowHeadersLayout?: any;
	compactColumnHeaderIndentation?: number;
	compactRowHeaderIndentation?: number;
	defaultRowHeaderWidth?: number;
	allowSorting?: boolean;
	firstSortDirection?: any;
	allowHeaderRowsSorting?: boolean;
	allowHeaderColumnsSorting?: boolean;
	levelSortDirections?: IgPivotViewPivotGridOptionsLevelSortDirection[];
	firstLevelSortDirection?: any;
	gridOptions?: IgPivotViewPivotGridOptionsGridOptions;
	dragAndDropSettings?: IgPivotViewPivotGridOptionsDragAndDropSettings;
	dropDownParent?: any;
	disableRowsDropArea?: boolean;
	disableColumnsDropArea?: boolean;
	disableMeasuresDropArea?: boolean;
	disableFiltersDropArea?: boolean;
	hideRowsDropArea?: boolean;
	hideColumnsDropArea?: boolean;
	hideMeasuresDropArea?: boolean;
	hideFiltersDropArea?: boolean;
	customMoveValidation?: Function;
}

interface IgPivotViewDataSelectorOptionsDragAndDropSettings {
	appendTo?: any;
	containment?: any;
	zIndex?: number;
}

interface IgPivotViewDataSelectorOptions {
	dragAndDropSettings?: IgPivotViewDataSelectorOptionsDragAndDropSettings;
	dropDownParent?: any;
	customMoveValidation?: Function;
}

interface IgPivotViewPivotGridPanel {
	resizable?: boolean;
	collapsible?: boolean;
	collapsed?: boolean;
	size?: any;
}

interface IgPivotViewDataSelectorPanel {
	location?: any;
	resizable?: boolean;
	collapsible?: boolean;
	collapsed?: boolean;
	size?: any;
}

interface IgPivotView {
	width?: any;
	height?: any;
	dataSource?: any;
	dataSourceOptions?: IgPivotViewDataSourceOptions;
	pivotGridOptions?: IgPivotViewPivotGridOptions;
	dataSelectorOptions?: IgPivotViewDataSelectorOptions;
	pivotGridPanel?: IgPivotViewPivotGridPanel;
	dataSelectorPanel?: IgPivotViewDataSelectorPanel;
}
interface IgPivotViewMethods {
	pivotGrid(): Object;
	dataSelector(): Object;
	splitter(): Object;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igPivotView"):IgPivotViewMethods;
}

interface JQuery {
	igPivotView(methodName: "pivotGrid"): Object;
	igPivotView(methodName: "dataSelector"): Object;
	igPivotView(methodName: "splitter"): Object;
	igPivotView(methodName: "destroy"): void;
	igPivotView(optionLiteral: 'option', optionName: "width"): any;
	igPivotView(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igPivotView(optionLiteral: 'option', optionName: "height"): any;
	igPivotView(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igPivotView(optionLiteral: 'option', optionName: "dataSource"): any;
	igPivotView(optionLiteral: 'option', optionName: "dataSource", optionValue: any): void;
	igPivotView(optionLiteral: 'option', optionName: "dataSourceOptions"): IgPivotViewDataSourceOptions;
	igPivotView(optionLiteral: 'option', optionName: "dataSourceOptions", optionValue: IgPivotViewDataSourceOptions): void;
	igPivotView(optionLiteral: 'option', optionName: "pivotGridOptions"): IgPivotViewPivotGridOptions;
	igPivotView(optionLiteral: 'option', optionName: "pivotGridOptions", optionValue: IgPivotViewPivotGridOptions): void;
	igPivotView(optionLiteral: 'option', optionName: "dataSelectorOptions"): IgPivotViewDataSelectorOptions;
	igPivotView(optionLiteral: 'option', optionName: "dataSelectorOptions", optionValue: IgPivotViewDataSelectorOptions): void;
	igPivotView(optionLiteral: 'option', optionName: "pivotGridPanel"): IgPivotViewPivotGridPanel;
	igPivotView(optionLiteral: 'option', optionName: "pivotGridPanel", optionValue: IgPivotViewPivotGridPanel): void;
	igPivotView(optionLiteral: 'option', optionName: "dataSelectorPanel"): IgPivotViewDataSelectorPanel;
	igPivotView(optionLiteral: 'option', optionName: "dataSelectorPanel", optionValue: IgPivotViewDataSelectorPanel): void;
	igPivotView(options: IgPivotView): JQuery;
	igPivotView(optionLiteral: 'option', optionName: string): any;
	igPivotView(optionLiteral: 'option', options: IgPivotView): JQuery;
	igPivotView(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igPivotView(methodName: string, ...methodParams: any[]): any;
}
interface IgPopover {
	closeOnBlur?: boolean;
	direction?: any;
	position?: any;
	width?: any;
	height?: any;
	minWidth?: any;
	maxWidth?: any;
	maxHeight?: any;
	animationDuration?: number;
	contentTemplate?: any;
	selectors?: string;
	headerTemplate?: IgPopoverHeaderTemplate;
	showOn?: any;
	containment?: any;
	showing?: ShowingEvent;
	shown?: ShownEvent;
	hiding?: HidingEvent;
	hidden?: HiddenEvent;
}
interface IgPopoverMethods {
	destroy(): void;
	id(): string;
	container(): Object;
	show(trg?: Element, content?: string): void;
	hide(): void;
	getContent(): string;
	setContent(newCnt: string): void;
	target(): Object;
	getCoordinates(): Object;
	setCoordinates(pos: Object): void;
}
interface JQuery {
	data(propertyName: "igPopover"):IgPopoverMethods;
}

interface JQuery {
	igPopover(methodName: "destroy"): void;
	igPopover(methodName: "id"): string;
	igPopover(methodName: "container"): Object;
	igPopover(methodName: "show", trg?: Element, content?: string): void;
	igPopover(methodName: "hide"): void;
	igPopover(methodName: "getContent"): string;
	igPopover(methodName: "setContent", newCnt: string): void;
	igPopover(methodName: "target"): Object;
	igPopover(methodName: "getCoordinates"): Object;
	igPopover(methodName: "setCoordinates", pos: Object): void;
	igPopover(optionLiteral: 'option', optionName: "closeOnBlur"): boolean;
	igPopover(optionLiteral: 'option', optionName: "closeOnBlur", optionValue: boolean): void;
	igPopover(optionLiteral: 'option', optionName: "direction"): any;
	igPopover(optionLiteral: 'option', optionName: "direction", optionValue: any): void;
	igPopover(optionLiteral: 'option', optionName: "position"): any;
	igPopover(optionLiteral: 'option', optionName: "position", optionValue: any): void;
	igPopover(optionLiteral: 'option', optionName: "width"): any;
	igPopover(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igPopover(optionLiteral: 'option', optionName: "height"): any;
	igPopover(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igPopover(optionLiteral: 'option', optionName: "minWidth"): any;
	igPopover(optionLiteral: 'option', optionName: "minWidth", optionValue: any): void;
	igPopover(optionLiteral: 'option', optionName: "maxWidth"): any;
	igPopover(optionLiteral: 'option', optionName: "maxWidth", optionValue: any): void;
	igPopover(optionLiteral: 'option', optionName: "maxHeight"): any;
	igPopover(optionLiteral: 'option', optionName: "maxHeight", optionValue: any): void;
	igPopover(optionLiteral: 'option', optionName: "animationDuration"): number;
	igPopover(optionLiteral: 'option', optionName: "animationDuration", optionValue: number): void;
	igPopover(optionLiteral: 'option', optionName: "contentTemplate"): any;
	igPopover(optionLiteral: 'option', optionName: "contentTemplate", optionValue: any): void;
	igPopover(optionLiteral: 'option', optionName: "selectors"): string;
	igPopover(optionLiteral: 'option', optionName: "selectors", optionValue: string): void;
	igPopover(optionLiteral: 'option', optionName: "headerTemplate"): IgPopoverHeaderTemplate;
	igPopover(optionLiteral: 'option', optionName: "headerTemplate", optionValue: IgPopoverHeaderTemplate): void;
	igPopover(optionLiteral: 'option', optionName: "showOn"): any;
	igPopover(optionLiteral: 'option', optionName: "showOn", optionValue: any): void;
	igPopover(optionLiteral: 'option', optionName: "containment"): any;
	igPopover(optionLiteral: 'option', optionName: "containment", optionValue: any): void;
	igPopover(optionLiteral: 'option', optionName: "showing"): ShowingEvent;
	igPopover(optionLiteral: 'option', optionName: "showing", optionValue: ShowingEvent): void;
	igPopover(optionLiteral: 'option', optionName: "shown"): ShownEvent;
	igPopover(optionLiteral: 'option', optionName: "shown", optionValue: ShownEvent): void;
	igPopover(optionLiteral: 'option', optionName: "hiding"): HidingEvent;
	igPopover(optionLiteral: 'option', optionName: "hiding", optionValue: HidingEvent): void;
	igPopover(optionLiteral: 'option', optionName: "hidden"): HiddenEvent;
	igPopover(optionLiteral: 'option', optionName: "hidden", optionValue: HiddenEvent): void;
	igPopover(options: IgPopover): JQuery;
	igPopover(optionLiteral: 'option', optionName: string): any;
	igPopover(optionLiteral: 'option', options: IgPopover): JQuery;
	igPopover(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igPopover(methodName: string, ...methodParams: any[]): any;
}
interface IgRadialGaugeRange {
	name?: string;
	startValue?: number;
	endValue?: number;
	outerStartExtent?: number;
	outerEndExtent?: number;
	innerStartExtent?: number;
	innerEndExtent?: number;
	brush?: string;
	outline?: string;
	strokeThickness?: number;
	remove?: boolean;
}

interface IgRadialGauge {
	width?: any;
	height?: any;
	ranges?: IgRadialGaugeRange[];
	rangeBrushes?: any;
	rangeOutlines?: any;
	minimumValue?: number;
	maximumValue?: number;
	interval?: number;
	centerX?: number;
	centerY?: number;
	value?: number;
	scaleStartAngle?: number;
	scaleEndAngle?: number;
	scaleSweepDirection?: any;
	transitionDuration?: number;
	transitionEasingFunction?: any;
	needleBrush?: string;
	needleOutline?: string;
	needleStartExtent?: number;
	needleEndExtent?: number;
	needleShape?: any;
	needleStartWidthRatio?: number;
	needleEndWidthRatio?: number;
	needleBaseFeatureWidthRatio?: number;
	needleBaseFeatureExtent?: number;
	needlePointFeatureWidthRatio?: number;
	needlePointFeatureExtent?: number;
	needlePivotWidthRatio?: number;
	needlePivotInnerWidthRatio?: number;
	needlePivotShape?: any;
	scaleStartExtent?: number;
	needlePivotBrush?: string;
	needlePivotOutline?: string;
	needleStrokeThickness?: number;
	needlePivotStrokeThickness?: number;
	scaleEndExtent?: number;
	labelExtent?: number;
	labelInterval?: number;
	tickStartExtent?: number;
	tickEndExtent?: number;
	tickStrokeThickness?: number;
	tickBrush?: string;
	fontBrush?: string;
	minorTickStartExtent?: number;
	minorTickEndExtent?: number;
	minorTickStrokeThickness?: number;
	minorTickBrush?: string;
	minorTickCount?: number;
	scaleBrush?: string;
	backingBrush?: string;
	backingOutline?: string;
	backingStrokeThickness?: number;
	backingOuterExtent?: number;
	backingOversweep?: number;
	scaleOversweep?: number;
	scaleOversweepShape?: any;
	backingCornerRadius?: number;
	backingInnerExtent?: number;
	backingShape?: any;
	radiusMultiplier?: number;
	duplicateLabelOmissionStrategy?: any;
	font?: any;
	transitionProgress?: number;
	formatLabel?: FormatLabelEvent;
	alignLabel?: AlignLabelEvent;
}
interface IgRadialGaugeMethods {
	getRangeNames(): string;
	addRange(value: Object): void;
	removeRange(value: Object): void;
	updateRange(value: Object): void;
	clearRanges(): void;
	scaleValue(value: Object): void;
	unscaleValue(value: Object): void;
	getValueForPoint(x: Object, y: Object): number;
	needleContainsPoint(x: Object, y: Object): void;
	exportVisualData(): void;
	flush(): void;
	destroy(): void;
	styleUpdated(): void;
}
interface JQuery {
	data(propertyName: "igRadialGauge"):IgRadialGaugeMethods;
}

interface JQuery {
	igRadialGauge(methodName: "getRangeNames"): string;
	igRadialGauge(methodName: "addRange", value: Object): void;
	igRadialGauge(methodName: "removeRange", value: Object): void;
	igRadialGauge(methodName: "updateRange", value: Object): void;
	igRadialGauge(methodName: "clearRanges"): void;
	igRadialGauge(methodName: "scaleValue", value: Object): void;
	igRadialGauge(methodName: "unscaleValue", value: Object): void;
	igRadialGauge(methodName: "getValueForPoint", x: Object, y: Object): number;
	igRadialGauge(methodName: "needleContainsPoint", x: Object, y: Object): void;
	igRadialGauge(methodName: "exportVisualData"): void;
	igRadialGauge(methodName: "flush"): void;
	igRadialGauge(methodName: "destroy"): void;
	igRadialGauge(methodName: "styleUpdated"): void;
	igRadialGauge(optionLiteral: 'option', optionName: "width"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "height"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "ranges"): IgRadialGaugeRange[];
	igRadialGauge(optionLiteral: 'option', optionName: "ranges", optionValue: IgRadialGaugeRange[]): void;
	igRadialGauge(optionLiteral: 'option', optionName: "rangeBrushes"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "rangeBrushes", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "rangeOutlines"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "rangeOutlines", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "minimumValue"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "minimumValue", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "maximumValue"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "maximumValue", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "interval"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "interval", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "centerX"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "centerX", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "centerY"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "centerY", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "value"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "value", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleStartAngle"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleStartAngle", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleEndAngle"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleEndAngle", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleSweepDirection"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleSweepDirection", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "transitionDuration"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "transitionDuration", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "transitionEasingFunction"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "transitionEasingFunction", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needleBrush"): string;
	igRadialGauge(optionLiteral: 'option', optionName: "needleBrush", optionValue: string): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needleOutline"): string;
	igRadialGauge(optionLiteral: 'option', optionName: "needleOutline", optionValue: string): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needleStartExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needleStartExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needleEndExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needleEndExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needleShape"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "needleShape", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needleStartWidthRatio"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needleStartWidthRatio", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needleEndWidthRatio"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needleEndWidthRatio", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needleBaseFeatureWidthRatio"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needleBaseFeatureWidthRatio", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needleBaseFeatureExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needleBaseFeatureExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePointFeatureWidthRatio"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePointFeatureWidthRatio", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePointFeatureExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePointFeatureExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotWidthRatio"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotWidthRatio", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotInnerWidthRatio"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotInnerWidthRatio", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotShape"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotShape", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleStartExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleStartExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotBrush"): string;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotBrush", optionValue: string): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotOutline"): string;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotOutline", optionValue: string): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needleStrokeThickness"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needleStrokeThickness", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotStrokeThickness"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "needlePivotStrokeThickness", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleEndExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleEndExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "labelExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "labelExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "labelInterval"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "labelInterval", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "tickStartExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "tickStartExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "tickEndExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "tickEndExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "tickStrokeThickness"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "tickStrokeThickness", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "tickBrush"): string;
	igRadialGauge(optionLiteral: 'option', optionName: "tickBrush", optionValue: string): void;
	igRadialGauge(optionLiteral: 'option', optionName: "fontBrush"): string;
	igRadialGauge(optionLiteral: 'option', optionName: "fontBrush", optionValue: string): void;
	igRadialGauge(optionLiteral: 'option', optionName: "minorTickStartExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "minorTickStartExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "minorTickEndExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "minorTickEndExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "minorTickStrokeThickness"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "minorTickStrokeThickness", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "minorTickBrush"): string;
	igRadialGauge(optionLiteral: 'option', optionName: "minorTickBrush", optionValue: string): void;
	igRadialGauge(optionLiteral: 'option', optionName: "minorTickCount"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "minorTickCount", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleBrush"): string;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleBrush", optionValue: string): void;
	igRadialGauge(optionLiteral: 'option', optionName: "backingBrush"): string;
	igRadialGauge(optionLiteral: 'option', optionName: "backingBrush", optionValue: string): void;
	igRadialGauge(optionLiteral: 'option', optionName: "backingOutline"): string;
	igRadialGauge(optionLiteral: 'option', optionName: "backingOutline", optionValue: string): void;
	igRadialGauge(optionLiteral: 'option', optionName: "backingStrokeThickness"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "backingStrokeThickness", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "backingOuterExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "backingOuterExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "backingOversweep"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "backingOversweep", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleOversweep"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleOversweep", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleOversweepShape"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "scaleOversweepShape", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "backingCornerRadius"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "backingCornerRadius", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "backingInnerExtent"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "backingInnerExtent", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "backingShape"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "backingShape", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "radiusMultiplier"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "radiusMultiplier", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "duplicateLabelOmissionStrategy"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "duplicateLabelOmissionStrategy", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "font"): any;
	igRadialGauge(optionLiteral: 'option', optionName: "font", optionValue: any): void;
	igRadialGauge(optionLiteral: 'option', optionName: "transitionProgress"): number;
	igRadialGauge(optionLiteral: 'option', optionName: "transitionProgress", optionValue: number): void;
	igRadialGauge(optionLiteral: 'option', optionName: "formatLabel"): FormatLabelEvent;
	igRadialGauge(optionLiteral: 'option', optionName: "formatLabel", optionValue: FormatLabelEvent): void;
	igRadialGauge(optionLiteral: 'option', optionName: "alignLabel"): AlignLabelEvent;
	igRadialGauge(optionLiteral: 'option', optionName: "alignLabel", optionValue: AlignLabelEvent): void;
	igRadialGauge(options: IgRadialGauge): JQuery;
	igRadialGauge(optionLiteral: 'option', optionName: string): any;
	igRadialGauge(optionLiteral: 'option', options: IgRadialGauge): JQuery;
	igRadialGauge(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igRadialGauge(methodName: string, ...methodParams: any[]): any;
}
interface IgRadialMenuItem {
	type?: any;
	name?: string;
	recentItemName?: string;
	value?: number;
	pendingValue?: any;
	autoRotateChildren?: boolean;
	checkedHighlightBrush?: string;
	foreground?: string;
	highlightBrush?: string;
	innerAreaFill?: string;
	innerAreaHotTrackFill?: string;
	innerAreaHotTrackStroke?: string;
	innerAreaStroke?: string;
	innerAreaStrokeThickness?: number;
	isEnabled?: boolean;
	isToolTipEnabled?: boolean;
	outerRingButtonHotTrackFill?: string;
	outerRingButtonHotTrackForeground?: string;
	outerRingButtonHotTrackStroke?: string;
	outerRingButtonFill?: string;
	outerRingButtonForeground?: string;
	outerRingButtonStroke?: string;
	outerRingButtonStrokeThickness?: number;
	toolTip?: any;
	wedgeIndex?: number;
	wedgeSpan?: number;
	autoUpdateRecentItem?: boolean;
	childItemPlacement?: any;
	checkBehavior?: any;
	isChecked?: boolean;
	groupName?: string;
	header?: any;
	iconUri?: string;
	color?: any;
	pendingValueNeedleBrush?: string;
	reserveFirstSlice?: boolean;
	smallIncrement?: number;
	tickBrush?: string;
	ticks?: any;
	trackStartColor?: any;
	trackEndColor?: any;
	valueNeedleBrush?: string;
	closed?: any;
	opened?: any;
	checked?: any;
	click?: any;
	unchecked?: any;
	colorChanged?: any;
	colorWellClick?: any;
	valueChanged?: any;
	pendingValueChanged?: any;
}

interface ClosedEvent {
	(event: Event, ui: ClosedEventUIParam): void;
}

interface ClosedEventUIParam {
	owner?: any;
}

interface OpenedEvent {
	(event: Event, ui: OpenedEventUIParam): void;
}

interface OpenedEventUIParam {
	owner?: any;
}

interface IgRadialMenu {
	items?: IgRadialMenuItem[];
	currentOpenMenuItemName?: string;
	centerButtonContentWidth?: number;
	centerButtonContentHeight?: number;
	centerButtonClosedFill?: string;
	centerButtonClosedStroke?: string;
	centerButtonFill?: string;
	centerButtonHotTrackFill?: string;
	centerButtonHotTrackStroke?: string;
	centerButtonStroke?: string;
	centerButtonStrokeThickness?: number;
	font?: string;
	isOpen?: boolean;
	menuBackground?: string;
	menuItemOpenCloseAnimationDuration?: number;
	menuItemOpenCloseAnimationEasingFunction?: any;
	menuOpenCloseAnimationDuration?: number;
	menuOpenCloseAnimationEasingFunction?: any;
	minWedgeCount?: number;
	outerRingFill?: string;
	outerRingThickness?: number;
	outerRingStroke?: string;
	outerRingStrokeThickness?: number;
	rotationInDegrees?: number;
	rotationAsPercentageOfWedge?: number;
	wedgePaddingInDegrees?: number;
	closed?: ClosedEvent;
	opened?: OpenedEvent;
}
interface IgRadialMenuMethods {
	itemOption(itemKey: string, key: string, value: Object): Object;
	exportVisualData(): void;
	flush(): void;
	destroy(): void;
	styleUpdated(): void;
}
interface JQuery {
	data(propertyName: "igRadialMenu"):IgRadialMenuMethods;
}

interface JQuery {
	igRadialMenu(methodName: "itemOption", itemKey: string, key: string, value: Object): Object;
	igRadialMenu(methodName: "exportVisualData"): void;
	igRadialMenu(methodName: "flush"): void;
	igRadialMenu(methodName: "destroy"): void;
	igRadialMenu(methodName: "styleUpdated"): void;
	igRadialMenu(optionLiteral: 'option', optionName: "items"): IgRadialMenuItem[];
	igRadialMenu(optionLiteral: 'option', optionName: "items", optionValue: IgRadialMenuItem[]): void;
	igRadialMenu(optionLiteral: 'option', optionName: "currentOpenMenuItemName"): string;
	igRadialMenu(optionLiteral: 'option', optionName: "currentOpenMenuItemName", optionValue: string): void;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonContentWidth"): number;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonContentWidth", optionValue: number): void;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonContentHeight"): number;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonContentHeight", optionValue: number): void;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonClosedFill"): string;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonClosedFill", optionValue: string): void;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonClosedStroke"): string;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonClosedStroke", optionValue: string): void;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonFill"): string;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonFill", optionValue: string): void;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonHotTrackFill"): string;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonHotTrackFill", optionValue: string): void;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonHotTrackStroke"): string;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonHotTrackStroke", optionValue: string): void;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonStroke"): string;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonStroke", optionValue: string): void;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonStrokeThickness"): number;
	igRadialMenu(optionLiteral: 'option', optionName: "centerButtonStrokeThickness", optionValue: number): void;
	igRadialMenu(optionLiteral: 'option', optionName: "font"): string;
	igRadialMenu(optionLiteral: 'option', optionName: "font", optionValue: string): void;
	igRadialMenu(optionLiteral: 'option', optionName: "isOpen"): boolean;
	igRadialMenu(optionLiteral: 'option', optionName: "isOpen", optionValue: boolean): void;
	igRadialMenu(optionLiteral: 'option', optionName: "menuBackground"): string;
	igRadialMenu(optionLiteral: 'option', optionName: "menuBackground", optionValue: string): void;
	igRadialMenu(optionLiteral: 'option', optionName: "menuItemOpenCloseAnimationDuration"): number;
	igRadialMenu(optionLiteral: 'option', optionName: "menuItemOpenCloseAnimationDuration", optionValue: number): void;
	igRadialMenu(optionLiteral: 'option', optionName: "menuItemOpenCloseAnimationEasingFunction"): any;
	igRadialMenu(optionLiteral: 'option', optionName: "menuItemOpenCloseAnimationEasingFunction", optionValue: any): void;
	igRadialMenu(optionLiteral: 'option', optionName: "menuOpenCloseAnimationDuration"): number;
	igRadialMenu(optionLiteral: 'option', optionName: "menuOpenCloseAnimationDuration", optionValue: number): void;
	igRadialMenu(optionLiteral: 'option', optionName: "menuOpenCloseAnimationEasingFunction"): any;
	igRadialMenu(optionLiteral: 'option', optionName: "menuOpenCloseAnimationEasingFunction", optionValue: any): void;
	igRadialMenu(optionLiteral: 'option', optionName: "minWedgeCount"): number;
	igRadialMenu(optionLiteral: 'option', optionName: "minWedgeCount", optionValue: number): void;
	igRadialMenu(optionLiteral: 'option', optionName: "outerRingFill"): string;
	igRadialMenu(optionLiteral: 'option', optionName: "outerRingFill", optionValue: string): void;
	igRadialMenu(optionLiteral: 'option', optionName: "outerRingThickness"): number;
	igRadialMenu(optionLiteral: 'option', optionName: "outerRingThickness", optionValue: number): void;
	igRadialMenu(optionLiteral: 'option', optionName: "outerRingStroke"): string;
	igRadialMenu(optionLiteral: 'option', optionName: "outerRingStroke", optionValue: string): void;
	igRadialMenu(optionLiteral: 'option', optionName: "outerRingStrokeThickness"): number;
	igRadialMenu(optionLiteral: 'option', optionName: "outerRingStrokeThickness", optionValue: number): void;
	igRadialMenu(optionLiteral: 'option', optionName: "rotationInDegrees"): number;
	igRadialMenu(optionLiteral: 'option', optionName: "rotationInDegrees", optionValue: number): void;
	igRadialMenu(optionLiteral: 'option', optionName: "rotationAsPercentageOfWedge"): number;
	igRadialMenu(optionLiteral: 'option', optionName: "rotationAsPercentageOfWedge", optionValue: number): void;
	igRadialMenu(optionLiteral: 'option', optionName: "wedgePaddingInDegrees"): number;
	igRadialMenu(optionLiteral: 'option', optionName: "wedgePaddingInDegrees", optionValue: number): void;
	igRadialMenu(optionLiteral: 'option', optionName: "closed"): ClosedEvent;
	igRadialMenu(optionLiteral: 'option', optionName: "closed", optionValue: ClosedEvent): void;
	igRadialMenu(optionLiteral: 'option', optionName: "opened"): OpenedEvent;
	igRadialMenu(optionLiteral: 'option', optionName: "opened", optionValue: OpenedEvent): void;
	igRadialMenu(options: IgRadialMenu): JQuery;
	igRadialMenu(optionLiteral: 'option', optionName: string): any;
	igRadialMenu(optionLiteral: 'option', options: IgRadialMenu): JQuery;
	igRadialMenu(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igRadialMenu(methodName: string, ...methodParams: any[]): any;
}
interface HoverChangeEvent {
	(event: Event, ui: HoverChangeEventUIParam): void;
}

interface HoverChangeEventUIParam {
	value?: any;
	oldValue?: any;
}

interface ValueChangeEvent {
	(event: Event, ui: ValueChangeEventUIParam): void;
}

interface ValueChangeEventUIParam {
	value?: any;
	oldValue?: any;
}

interface IgRating {
	vertical?: boolean;
	value?: number;
	valueHover?: number;
	voteCount?: number;
	voteWidth?: number;
	voteHeight?: number;
	swapDirection?: boolean;
	valueAsPercent?: boolean;
	focusable?: boolean;
	precision?: any;
	precisionZeroVote?: number;
	roundedDecimalPlaces?: number;
	theme?: string;
	validatorOptions?: any;
	cssVotes?: any;
	hoverChange?: HoverChangeEvent;
	valueChange?: ValueChangeEvent;
}
interface IgRatingMethods {
	validator(destroy?: boolean): Object;
	validate(): void;
	value(val: number): void;
	valueHover(val?: number): void;
	hasFocus(): boolean;
	focus(): Object;
	destroy(): Object;
}
interface JQuery {
	data(propertyName: "igRating"):IgRatingMethods;
}

interface JQuery {
	igRating(methodName: "validator", destroy?: boolean): Object;
	igRating(methodName: "validate"): void;
	igRating(methodName: "value", val: number): void;
	igRating(methodName: "valueHover", val?: number): void;
	igRating(methodName: "hasFocus"): boolean;
	igRating(methodName: "focus"): Object;
	igRating(methodName: "destroy"): Object;
	igRating(optionLiteral: 'option', optionName: "vertical"): boolean;
	igRating(optionLiteral: 'option', optionName: "vertical", optionValue: boolean): void;
	igRating(optionLiteral: 'option', optionName: "value"): number;
	igRating(optionLiteral: 'option', optionName: "value", optionValue: number): void;
	igRating(optionLiteral: 'option', optionName: "valueHover"): number;
	igRating(optionLiteral: 'option', optionName: "valueHover", optionValue: number): void;
	igRating(optionLiteral: 'option', optionName: "voteCount"): number;
	igRating(optionLiteral: 'option', optionName: "voteCount", optionValue: number): void;
	igRating(optionLiteral: 'option', optionName: "voteWidth"): number;
	igRating(optionLiteral: 'option', optionName: "voteWidth", optionValue: number): void;
	igRating(optionLiteral: 'option', optionName: "voteHeight"): number;
	igRating(optionLiteral: 'option', optionName: "voteHeight", optionValue: number): void;
	igRating(optionLiteral: 'option', optionName: "swapDirection"): boolean;
	igRating(optionLiteral: 'option', optionName: "swapDirection", optionValue: boolean): void;
	igRating(optionLiteral: 'option', optionName: "valueAsPercent"): boolean;
	igRating(optionLiteral: 'option', optionName: "valueAsPercent", optionValue: boolean): void;
	igRating(optionLiteral: 'option', optionName: "focusable"): boolean;
	igRating(optionLiteral: 'option', optionName: "focusable", optionValue: boolean): void;
	igRating(optionLiteral: 'option', optionName: "precision"): any;
	igRating(optionLiteral: 'option', optionName: "precision", optionValue: any): void;
	igRating(optionLiteral: 'option', optionName: "precisionZeroVote"): number;
	igRating(optionLiteral: 'option', optionName: "precisionZeroVote", optionValue: number): void;
	igRating(optionLiteral: 'option', optionName: "roundedDecimalPlaces"): number;
	igRating(optionLiteral: 'option', optionName: "roundedDecimalPlaces", optionValue: number): void;
	igRating(optionLiteral: 'option', optionName: "theme"): string;
	igRating(optionLiteral: 'option', optionName: "theme", optionValue: string): void;
	igRating(optionLiteral: 'option', optionName: "validatorOptions"): any;
	igRating(optionLiteral: 'option', optionName: "validatorOptions", optionValue: any): void;
	igRating(optionLiteral: 'option', optionName: "cssVotes"): any;
	igRating(optionLiteral: 'option', optionName: "cssVotes", optionValue: any): void;
	igRating(optionLiteral: 'option', optionName: "hoverChange"): HoverChangeEvent;
	igRating(optionLiteral: 'option', optionName: "hoverChange", optionValue: HoverChangeEvent): void;
	igRating(optionLiteral: 'option', optionName: "valueChange"): ValueChangeEvent;
	igRating(optionLiteral: 'option', optionName: "valueChange", optionValue: ValueChangeEvent): void;
	igRating(options: IgRating): JQuery;
	igRating(optionLiteral: 'option', optionName: string): any;
	igRating(optionLiteral: 'option', options: IgRating): JQuery;
	igRating(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igRating(methodName: string, ...methodParams: any[]): any;
}
interface StartingEvent {
	(event: Event, ui: StartingEventUIParam): void;
}

interface StartingEventUIParam {
	owner?: any;
}

interface StartedEvent {
	(event: Event, ui: StartedEventUIParam): void;
}

interface StartedEventUIParam {
	owner?: any;
}

interface ScrollingEvent {
	(event: Event, ui: ScrollingEventUIParam): void;
}

interface ScrollingEventUIParam {
	owner?: any;
	deltaX?: any;
	deltaY?: any;
}

interface ScrolledEvent {
	(event: Event, ui: ScrolledEventUIParam): void;
}

interface ScrolledEventUIParam {
	owner?: any;
	deltaX?: any;
	deltaY?: any;
}

interface StoppedEvent {
	(event: Event, ui: StoppedEventUIParam): void;
}

interface StoppedEventUIParam {
	owner?: any;
}

interface IgScroll {
	thumbOpacityDrag?: number;
	thumbOpacity?: boolean;
	cancelStart?: boolean;
	oneDirection?: boolean;
	direction?: any;
	animateShowDuration?: number;
	animateHideDuration?: number;
	hideThumbsDelay?: number;
	hideDragThumbsDelay?: number;
	xInertia?: number;
	yInertia?: number;
	xThumb?: any;
	yThumb?: any;
	xLabel?: any;
	yLabel?: any;
	marginLeft?: number;
	marginRight?: number;
	marginTop?: number;
	marginBottom?: number;
	xScroller?: Element;
	yScroller?: Element;
	starting?: StartingEvent;
	started?: StartedEvent;
	scrolling?: ScrollingEvent;
	scrolled?: ScrolledEvent;
	stopped?: StoppedEvent;
}
interface IgScrollMethods {
	scrollLeft(val?: number): void;
	scrollTop(val?: number): void;
	scrollWidth(): number;
	scrollHeight(): number;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igScroll"):IgScrollMethods;
}

interface JQuery {
	igScroll(methodName: "scrollLeft", val?: number): void;
	igScroll(methodName: "scrollTop", val?: number): void;
	igScroll(methodName: "scrollWidth"): number;
	igScroll(methodName: "scrollHeight"): number;
	igScroll(methodName: "destroy"): void;
	igScroll(optionLiteral: 'option', optionName: "thumbOpacityDrag"): number;
	igScroll(optionLiteral: 'option', optionName: "thumbOpacityDrag", optionValue: number): void;
	igScroll(optionLiteral: 'option', optionName: "thumbOpacity"): boolean;
	igScroll(optionLiteral: 'option', optionName: "thumbOpacity", optionValue: boolean): void;
	igScroll(optionLiteral: 'option', optionName: "cancelStart"): boolean;
	igScroll(optionLiteral: 'option', optionName: "cancelStart", optionValue: boolean): void;
	igScroll(optionLiteral: 'option', optionName: "oneDirection"): boolean;
	igScroll(optionLiteral: 'option', optionName: "oneDirection", optionValue: boolean): void;
	igScroll(optionLiteral: 'option', optionName: "direction"): any;
	igScroll(optionLiteral: 'option', optionName: "direction", optionValue: any): void;
	igScroll(optionLiteral: 'option', optionName: "animateShowDuration"): number;
	igScroll(optionLiteral: 'option', optionName: "animateShowDuration", optionValue: number): void;
	igScroll(optionLiteral: 'option', optionName: "animateHideDuration"): number;
	igScroll(optionLiteral: 'option', optionName: "animateHideDuration", optionValue: number): void;
	igScroll(optionLiteral: 'option', optionName: "hideThumbsDelay"): number;
	igScroll(optionLiteral: 'option', optionName: "hideThumbsDelay", optionValue: number): void;
	igScroll(optionLiteral: 'option', optionName: "hideDragThumbsDelay"): number;
	igScroll(optionLiteral: 'option', optionName: "hideDragThumbsDelay", optionValue: number): void;
	igScroll(optionLiteral: 'option', optionName: "xInertia"): number;
	igScroll(optionLiteral: 'option', optionName: "xInertia", optionValue: number): void;
	igScroll(optionLiteral: 'option', optionName: "yInertia"): number;
	igScroll(optionLiteral: 'option', optionName: "yInertia", optionValue: number): void;
	igScroll(optionLiteral: 'option', optionName: "xThumb"): any;
	igScroll(optionLiteral: 'option', optionName: "xThumb", optionValue: any): void;
	igScroll(optionLiteral: 'option', optionName: "yThumb"): any;
	igScroll(optionLiteral: 'option', optionName: "yThumb", optionValue: any): void;
	igScroll(optionLiteral: 'option', optionName: "xLabel"): any;
	igScroll(optionLiteral: 'option', optionName: "xLabel", optionValue: any): void;
	igScroll(optionLiteral: 'option', optionName: "yLabel"): any;
	igScroll(optionLiteral: 'option', optionName: "yLabel", optionValue: any): void;
	igScroll(optionLiteral: 'option', optionName: "marginLeft"): number;
	igScroll(optionLiteral: 'option', optionName: "marginLeft", optionValue: number): void;
	igScroll(optionLiteral: 'option', optionName: "marginRight"): number;
	igScroll(optionLiteral: 'option', optionName: "marginRight", optionValue: number): void;
	igScroll(optionLiteral: 'option', optionName: "marginTop"): number;
	igScroll(optionLiteral: 'option', optionName: "marginTop", optionValue: number): void;
	igScroll(optionLiteral: 'option', optionName: "marginBottom"): number;
	igScroll(optionLiteral: 'option', optionName: "marginBottom", optionValue: number): void;
	igScroll(optionLiteral: 'option', optionName: "xScroller"): Element;
	igScroll(optionLiteral: 'option', optionName: "xScroller", optionValue: Element): void;
	igScroll(optionLiteral: 'option', optionName: "yScroller"): Element;
	igScroll(optionLiteral: 'option', optionName: "yScroller", optionValue: Element): void;
	igScroll(optionLiteral: 'option', optionName: "starting"): StartingEvent;
	igScroll(optionLiteral: 'option', optionName: "starting", optionValue: StartingEvent): void;
	igScroll(optionLiteral: 'option', optionName: "started"): StartedEvent;
	igScroll(optionLiteral: 'option', optionName: "started", optionValue: StartedEvent): void;
	igScroll(optionLiteral: 'option', optionName: "scrolling"): ScrollingEvent;
	igScroll(optionLiteral: 'option', optionName: "scrolling", optionValue: ScrollingEvent): void;
	igScroll(optionLiteral: 'option', optionName: "scrolled"): ScrolledEvent;
	igScroll(optionLiteral: 'option', optionName: "scrolled", optionValue: ScrolledEvent): void;
	igScroll(optionLiteral: 'option', optionName: "stopped"): StoppedEvent;
	igScroll(optionLiteral: 'option', optionName: "stopped", optionValue: StoppedEvent): void;
	igScroll(options: IgScroll): JQuery;
	igScroll(optionLiteral: 'option', optionName: string): any;
	igScroll(optionLiteral: 'option', options: IgScroll): JQuery;
	igScroll(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igScroll(methodName: string, ...methodParams: any[]): any;
}
interface IgLoading {
	cssClass?: any;
	includeVerticalOffset?: boolean;
}
interface IgLoadingMethods {
	indicatorElement(): void;
	indicator(): void;
	show(refresh: Object): void;
	hide(): void;
	refreshPos(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igLoading"):IgLoadingMethods;
}

interface IgSliderBookmarks {
	value?: number;
	title?: string;
	disabled?: boolean;
	css?: string;
}

interface StartEvent {
	(event: Event, ui: StartEventUIParam): void;
}

interface StartEventUIParam {
}

interface SlideEvent {
	(event: Event, ui: SlideEventUIParam): void;
}

interface SlideEventUIParam {
}

interface StopEvent {
	(event: Event, ui: StopEventUIParam): void;
}

interface StopEventUIParam {
}

interface ChangeEvent {
	(event: Event, ui: ChangeEventUIParam): void;
}

interface ChangeEventUIParam {
}

interface BookmarkHitEvent {
	(event: Event, ui: BookmarkHitEventUIParam): void;
}

interface BookmarkHitEventUIParam {
}

interface BookmarkClickEvent {
	(event: Event, ui: BookmarkClickEventUIParam): void;
}

interface BookmarkClickEventUIParam {
}

interface IgSlider {
	animate?: boolean;
	max?: number;
	min?: number;
	orientation?: any;
	step?: number;
	value?: number;
	bookmarks?: IgSliderBookmarks;
	showBookmarkTitle?: boolean;
	syncHandleWithBookmark?: boolean;
	start?: StartEvent;
	slide?: SlideEvent;
	stop?: StopEvent;
	change?: ChangeEvent;
	bookmarkHit?: BookmarkHitEvent;
	bookmarkClick?: BookmarkClickEvent;
}
interface IgSliderMethods {
	widget(): void;
	destroy(): void;
	clearBookmarks(): void;
	value(newValue: Object): void;
}
interface JQuery {
	data(propertyName: "igSlider"):IgSliderMethods;
}

interface IgProgressBar {
	animate?: boolean;
	animateTimeout?: number;
	max?: number;
	min?: number;
	orientation?: string;
	value?: number;
	width?: string;
	height?: string;
	range?: boolean;
	queue?: boolean;
	endValue?: number;
	change?: ChangeEvent;
}
interface IgProgressBarMethods {
	widget(): void;
	destroy(): void;
	value(newValue: Object): void;
}
interface JQuery {
	data(propertyName: "igProgressBar"):IgProgressBarMethods;
}

interface IgButtonLink {
	href?: any;
	target?: any;
	title?: any;
}

interface IgButtonIcons {
	primary?: any;
	secondary?: any;
}

interface IgButton {
	width?: any;
	height?: any;
	link?: IgButtonLink;
	labelText?: string;
	centerLabel?: boolean;
	css?: any;
	onlyIcons?: boolean;
	icons?: IgButtonIcons;
	title?: boolean;
}
interface IgButtonMethods {
	setTitle(title: Object): void;
	widget(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igButton"):IgButtonMethods;
}

interface IgTooltip {
	text?: string;
	arrowLocation?: string;
}
interface IgTooltipMethods {
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igTooltip"):IgTooltipMethods;
}

interface CaptureEvent {
	(event: Event, ui: CaptureEventUIParam): void;
}

interface CaptureEventUIParam {
}

interface MouseWrapper {
	cancel?: string;
	distance?: number;
	delay?: number;
	start?: StartEvent;
	drag?: DragEvent;
	stop?: StopEvent;
	capture?: CaptureEvent;
}
interface MouseWrapperMethods {
	destroy(): void;
}
interface JQuery {
	data(propertyName: "mouseWrapper"):MouseWrapperMethods;
}

interface IgResponsiveContainer {
	pollingInterval?: number;
}
interface IgResponsiveContainerMethods {
	destroy(): void;
	startPoller(): void;
	stopPoller(): void;
	removeCallback(callbackId: number): void;
	addCallback(callback: Function, owner: Object, reactionStep: number, reactionDirection: Object): void;
}
interface JQuery {
	data(propertyName: "igResponsiveContainer"):IgResponsiveContainerMethods;
}

interface JQuery {
	igLoading(methodName: "indicatorElement"): void;
	igLoading(methodName: "indicator"): void;
	igLoading(methodName: "show", refresh: Object): void;
	igLoading(methodName: "hide"): void;
	igLoading(methodName: "refreshPos"): void;
	igLoading(methodName: "destroy"): void;
	igLoading(optionLiteral: 'option', optionName: "cssClass"): any;
	igLoading(optionLiteral: 'option', optionName: "cssClass", optionValue: any): void;
	igLoading(optionLiteral: 'option', optionName: "includeVerticalOffset"): boolean;
	igLoading(optionLiteral: 'option', optionName: "includeVerticalOffset", optionValue: boolean): void;
	igLoading(options: IgLoading): JQuery;
	igLoading(optionLiteral: 'option', optionName: string): any;
	igLoading(optionLiteral: 'option', options: IgLoading): JQuery;
	igLoading(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igLoading(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igSlider(methodName: "widget"): void;
	igSlider(methodName: "destroy"): void;
	igSlider(methodName: "clearBookmarks"): void;
	igSlider(methodName: "value", newValue: Object): void;
	igSlider(optionLiteral: 'option', optionName: "animate"): boolean;
	igSlider(optionLiteral: 'option', optionName: "animate", optionValue: boolean): void;
	igSlider(optionLiteral: 'option', optionName: "max"): number;
	igSlider(optionLiteral: 'option', optionName: "max", optionValue: number): void;
	igSlider(optionLiteral: 'option', optionName: "min"): number;
	igSlider(optionLiteral: 'option', optionName: "min", optionValue: number): void;
	igSlider(optionLiteral: 'option', optionName: "orientation"): any;
	igSlider(optionLiteral: 'option', optionName: "orientation", optionValue: any): void;
	igSlider(optionLiteral: 'option', optionName: "step"): number;
	igSlider(optionLiteral: 'option', optionName: "step", optionValue: number): void;
	igSlider(optionLiteral: 'option', optionName: "value"): number;
	igSlider(optionLiteral: 'option', optionName: "value", optionValue: number): void;
	igSlider(optionLiteral: 'option', optionName: "bookmarks"): IgSliderBookmarks;
	igSlider(optionLiteral: 'option', optionName: "bookmarks", optionValue: IgSliderBookmarks): void;
	igSlider(optionLiteral: 'option', optionName: "showBookmarkTitle"): boolean;
	igSlider(optionLiteral: 'option', optionName: "showBookmarkTitle", optionValue: boolean): void;
	igSlider(optionLiteral: 'option', optionName: "syncHandleWithBookmark"): boolean;
	igSlider(optionLiteral: 'option', optionName: "syncHandleWithBookmark", optionValue: boolean): void;
	igSlider(optionLiteral: 'option', optionName: "start"): StartEvent;
	igSlider(optionLiteral: 'option', optionName: "start", optionValue: StartEvent): void;
	igSlider(optionLiteral: 'option', optionName: "slide"): SlideEvent;
	igSlider(optionLiteral: 'option', optionName: "slide", optionValue: SlideEvent): void;
	igSlider(optionLiteral: 'option', optionName: "stop"): StopEvent;
	igSlider(optionLiteral: 'option', optionName: "stop", optionValue: StopEvent): void;
	igSlider(optionLiteral: 'option', optionName: "change"): ChangeEvent;
	igSlider(optionLiteral: 'option', optionName: "change", optionValue: ChangeEvent): void;
	igSlider(optionLiteral: 'option', optionName: "bookmarkHit"): BookmarkHitEvent;
	igSlider(optionLiteral: 'option', optionName: "bookmarkHit", optionValue: BookmarkHitEvent): void;
	igSlider(optionLiteral: 'option', optionName: "bookmarkClick"): BookmarkClickEvent;
	igSlider(optionLiteral: 'option', optionName: "bookmarkClick", optionValue: BookmarkClickEvent): void;
	igSlider(options: IgSlider): JQuery;
	igSlider(optionLiteral: 'option', optionName: string): any;
	igSlider(optionLiteral: 'option', options: IgSlider): JQuery;
	igSlider(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igSlider(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igProgressBar(methodName: "widget"): void;
	igProgressBar(methodName: "destroy"): void;
	igProgressBar(methodName: "value", newValue: Object): void;
	igProgressBar(optionLiteral: 'option', optionName: "animate"): boolean;
	igProgressBar(optionLiteral: 'option', optionName: "animate", optionValue: boolean): void;
	igProgressBar(optionLiteral: 'option', optionName: "animateTimeout"): number;
	igProgressBar(optionLiteral: 'option', optionName: "animateTimeout", optionValue: number): void;
	igProgressBar(optionLiteral: 'option', optionName: "max"): number;
	igProgressBar(optionLiteral: 'option', optionName: "max", optionValue: number): void;
	igProgressBar(optionLiteral: 'option', optionName: "min"): number;
	igProgressBar(optionLiteral: 'option', optionName: "min", optionValue: number): void;
	igProgressBar(optionLiteral: 'option', optionName: "orientation"): string;
	igProgressBar(optionLiteral: 'option', optionName: "orientation", optionValue: string): void;
	igProgressBar(optionLiteral: 'option', optionName: "value"): number;
	igProgressBar(optionLiteral: 'option', optionName: "value", optionValue: number): void;
	igProgressBar(optionLiteral: 'option', optionName: "width"): string;
	igProgressBar(optionLiteral: 'option', optionName: "width", optionValue: string): void;
	igProgressBar(optionLiteral: 'option', optionName: "height"): string;
	igProgressBar(optionLiteral: 'option', optionName: "height", optionValue: string): void;
	igProgressBar(optionLiteral: 'option', optionName: "range"): boolean;
	igProgressBar(optionLiteral: 'option', optionName: "range", optionValue: boolean): void;
	igProgressBar(optionLiteral: 'option', optionName: "queue"): boolean;
	igProgressBar(optionLiteral: 'option', optionName: "queue", optionValue: boolean): void;
	igProgressBar(optionLiteral: 'option', optionName: "endValue"): number;
	igProgressBar(optionLiteral: 'option', optionName: "endValue", optionValue: number): void;
	igProgressBar(optionLiteral: 'option', optionName: "change"): ChangeEvent;
	igProgressBar(optionLiteral: 'option', optionName: "change", optionValue: ChangeEvent): void;
	igProgressBar(options: IgProgressBar): JQuery;
	igProgressBar(optionLiteral: 'option', optionName: string): any;
	igProgressBar(optionLiteral: 'option', options: IgProgressBar): JQuery;
	igProgressBar(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igProgressBar(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igButton(methodName: "setTitle", title: Object): void;
	igButton(methodName: "widget"): void;
	igButton(methodName: "destroy"): void;
	igButton(optionLiteral: 'option', optionName: "width"): any;
	igButton(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igButton(optionLiteral: 'option', optionName: "height"): any;
	igButton(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igButton(optionLiteral: 'option', optionName: "link"): IgButtonLink;
	igButton(optionLiteral: 'option', optionName: "link", optionValue: IgButtonLink): void;
	igButton(optionLiteral: 'option', optionName: "labelText"): string;
	igButton(optionLiteral: 'option', optionName: "labelText", optionValue: string): void;
	igButton(optionLiteral: 'option', optionName: "centerLabel"): boolean;
	igButton(optionLiteral: 'option', optionName: "centerLabel", optionValue: boolean): void;
	igButton(optionLiteral: 'option', optionName: "css"): any;
	igButton(optionLiteral: 'option', optionName: "css", optionValue: any): void;
	igButton(optionLiteral: 'option', optionName: "onlyIcons"): boolean;
	igButton(optionLiteral: 'option', optionName: "onlyIcons", optionValue: boolean): void;
	igButton(optionLiteral: 'option', optionName: "icons"): IgButtonIcons;
	igButton(optionLiteral: 'option', optionName: "icons", optionValue: IgButtonIcons): void;
	igButton(optionLiteral: 'option', optionName: "title"): boolean;
	igButton(optionLiteral: 'option', optionName: "title", optionValue: boolean): void;
	igButton(options: IgButton): JQuery;
	igButton(optionLiteral: 'option', optionName: string): any;
	igButton(optionLiteral: 'option', options: IgButton): JQuery;
	igButton(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igButton(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igTooltip(methodName: "destroy"): void;
	igTooltip(optionLiteral: 'option', optionName: "text"): string;
	igTooltip(optionLiteral: 'option', optionName: "text", optionValue: string): void;
	igTooltip(optionLiteral: 'option', optionName: "arrowLocation"): string;
	igTooltip(optionLiteral: 'option', optionName: "arrowLocation", optionValue: string): void;
	igTooltip(options: IgTooltip): JQuery;
	igTooltip(optionLiteral: 'option', optionName: string): any;
	igTooltip(optionLiteral: 'option', options: IgTooltip): JQuery;
	igTooltip(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTooltip(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	mouseWrapper(methodName: "destroy"): void;
	mouseWrapper(optionLiteral: 'option', optionName: "cancel"): string;
	mouseWrapper(optionLiteral: 'option', optionName: "cancel", optionValue: string): void;
	mouseWrapper(optionLiteral: 'option', optionName: "distance"): number;
	mouseWrapper(optionLiteral: 'option', optionName: "distance", optionValue: number): void;
	mouseWrapper(optionLiteral: 'option', optionName: "delay"): number;
	mouseWrapper(optionLiteral: 'option', optionName: "delay", optionValue: number): void;
	mouseWrapper(optionLiteral: 'option', optionName: "start"): StartEvent;
	mouseWrapper(optionLiteral: 'option', optionName: "start", optionValue: StartEvent): void;
	mouseWrapper(optionLiteral: 'option', optionName: "drag"): DragEvent;
	mouseWrapper(optionLiteral: 'option', optionName: "drag", optionValue: DragEvent): void;
	mouseWrapper(optionLiteral: 'option', optionName: "stop"): StopEvent;
	mouseWrapper(optionLiteral: 'option', optionName: "stop", optionValue: StopEvent): void;
	mouseWrapper(optionLiteral: 'option', optionName: "capture"): CaptureEvent;
	mouseWrapper(optionLiteral: 'option', optionName: "capture", optionValue: CaptureEvent): void;
	mouseWrapper(options: MouseWrapper): JQuery;
	mouseWrapper(optionLiteral: 'option', optionName: string): any;
	mouseWrapper(optionLiteral: 'option', options: MouseWrapper): JQuery;
	mouseWrapper(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	mouseWrapper(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igResponsiveContainer(methodName: "destroy"): void;
	igResponsiveContainer(methodName: "startPoller"): void;
	igResponsiveContainer(methodName: "stopPoller"): void;
	igResponsiveContainer(methodName: "removeCallback", callbackId: number): void;
	igResponsiveContainer(methodName: "addCallback", callback: Function, owner: Object, reactionStep: number, reactionDirection: Object): void;
	igResponsiveContainer(optionLiteral: 'option', optionName: "pollingInterval"): number;
	igResponsiveContainer(optionLiteral: 'option', optionName: "pollingInterval", optionValue: number): void;
	igResponsiveContainer(options: IgResponsiveContainer): JQuery;
	igResponsiveContainer(optionLiteral: 'option', optionName: string): any;
	igResponsiveContainer(optionLiteral: 'option', options: IgResponsiveContainer): JQuery;
	igResponsiveContainer(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igResponsiveContainer(methodName: string, ...methodParams: any[]): any;
}
interface IgSparkline {
	width?: any;
	height?: any;
	brush?: string;
	negativeBrush?: string;
	markerBrush?: string;
	negativeMarkerBrush?: string;
	firstMarkerBrush?: string;
	lastMarkerBrush?: string;
	highMarkerBrush?: string;
	lowMarkerBrush?: string;
	trendLineBrush?: string;
	horizontalAxisBrush?: string;
	verticalAxisBrush?: string;
	normalRangeFill?: string;
	horizontalAxisVisibility?: any;
	verticalAxisVisibility?: any;
	markerVisibility?: any;
	negativeMarkerVisibility?: any;
	firstMarkerVisibility?: any;
	lastMarkerVisibility?: any;
	lowMarkerVisibility?: any;
	highMarkerVisibility?: any;
	normalRangeVisibility?: any;
	displayNormalRangeInFront?: boolean;
	markerSize?: number;
	firstMarkerSize?: number;
	lastMarkerSize?: number;
	highMarkerSize?: number;
	lowMarkerSize?: number;
	negativeMarkerSize?: number;
	lineThickness?: number;
	valueMemberPath?: string;
	labelMemberPath?: string;
	trendLineType?: any;
	trendLinePeriod?: number;
	trendLineThickness?: number;
	normalRangeMinimum?: number;
	normalRangeMaximum?: number;
	displayType?: any;
	unknownValuePlotting?: any;
	verticalAxisLabel?: any;
	horizontalAxisLabel?: any;
	formatLabel?: any;
	dataBinding?: DataBindingEvent;
	dataBound?: DataBoundEvent;
}
interface IgSparklineMethods {
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igSparkline"):IgSparklineMethods;
}

interface JQuery {
	igSparkline(methodName: "destroy"): void;
	igSparkline(optionLiteral: 'option', optionName: "width"): any;
	igSparkline(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "height"): any;
	igSparkline(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "brush"): string;
	igSparkline(optionLiteral: 'option', optionName: "brush", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "negativeBrush"): string;
	igSparkline(optionLiteral: 'option', optionName: "negativeBrush", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "markerBrush"): string;
	igSparkline(optionLiteral: 'option', optionName: "markerBrush", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "negativeMarkerBrush"): string;
	igSparkline(optionLiteral: 'option', optionName: "negativeMarkerBrush", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "firstMarkerBrush"): string;
	igSparkline(optionLiteral: 'option', optionName: "firstMarkerBrush", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "lastMarkerBrush"): string;
	igSparkline(optionLiteral: 'option', optionName: "lastMarkerBrush", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "highMarkerBrush"): string;
	igSparkline(optionLiteral: 'option', optionName: "highMarkerBrush", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "lowMarkerBrush"): string;
	igSparkline(optionLiteral: 'option', optionName: "lowMarkerBrush", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "trendLineBrush"): string;
	igSparkline(optionLiteral: 'option', optionName: "trendLineBrush", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "horizontalAxisBrush"): string;
	igSparkline(optionLiteral: 'option', optionName: "horizontalAxisBrush", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "verticalAxisBrush"): string;
	igSparkline(optionLiteral: 'option', optionName: "verticalAxisBrush", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "normalRangeFill"): string;
	igSparkline(optionLiteral: 'option', optionName: "normalRangeFill", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "horizontalAxisVisibility"): any;
	igSparkline(optionLiteral: 'option', optionName: "horizontalAxisVisibility", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "verticalAxisVisibility"): any;
	igSparkline(optionLiteral: 'option', optionName: "verticalAxisVisibility", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "markerVisibility"): any;
	igSparkline(optionLiteral: 'option', optionName: "markerVisibility", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "negativeMarkerVisibility"): any;
	igSparkline(optionLiteral: 'option', optionName: "negativeMarkerVisibility", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "firstMarkerVisibility"): any;
	igSparkline(optionLiteral: 'option', optionName: "firstMarkerVisibility", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "lastMarkerVisibility"): any;
	igSparkline(optionLiteral: 'option', optionName: "lastMarkerVisibility", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "lowMarkerVisibility"): any;
	igSparkline(optionLiteral: 'option', optionName: "lowMarkerVisibility", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "highMarkerVisibility"): any;
	igSparkline(optionLiteral: 'option', optionName: "highMarkerVisibility", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "normalRangeVisibility"): any;
	igSparkline(optionLiteral: 'option', optionName: "normalRangeVisibility", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "displayNormalRangeInFront"): boolean;
	igSparkline(optionLiteral: 'option', optionName: "displayNormalRangeInFront", optionValue: boolean): void;
	igSparkline(optionLiteral: 'option', optionName: "markerSize"): number;
	igSparkline(optionLiteral: 'option', optionName: "markerSize", optionValue: number): void;
	igSparkline(optionLiteral: 'option', optionName: "firstMarkerSize"): number;
	igSparkline(optionLiteral: 'option', optionName: "firstMarkerSize", optionValue: number): void;
	igSparkline(optionLiteral: 'option', optionName: "lastMarkerSize"): number;
	igSparkline(optionLiteral: 'option', optionName: "lastMarkerSize", optionValue: number): void;
	igSparkline(optionLiteral: 'option', optionName: "highMarkerSize"): number;
	igSparkline(optionLiteral: 'option', optionName: "highMarkerSize", optionValue: number): void;
	igSparkline(optionLiteral: 'option', optionName: "lowMarkerSize"): number;
	igSparkline(optionLiteral: 'option', optionName: "lowMarkerSize", optionValue: number): void;
	igSparkline(optionLiteral: 'option', optionName: "negativeMarkerSize"): number;
	igSparkline(optionLiteral: 'option', optionName: "negativeMarkerSize", optionValue: number): void;
	igSparkline(optionLiteral: 'option', optionName: "lineThickness"): number;
	igSparkline(optionLiteral: 'option', optionName: "lineThickness", optionValue: number): void;
	igSparkline(optionLiteral: 'option', optionName: "valueMemberPath"): string;
	igSparkline(optionLiteral: 'option', optionName: "valueMemberPath", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "labelMemberPath"): string;
	igSparkline(optionLiteral: 'option', optionName: "labelMemberPath", optionValue: string): void;
	igSparkline(optionLiteral: 'option', optionName: "trendLineType"): any;
	igSparkline(optionLiteral: 'option', optionName: "trendLineType", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "trendLinePeriod"): number;
	igSparkline(optionLiteral: 'option', optionName: "trendLinePeriod", optionValue: number): void;
	igSparkline(optionLiteral: 'option', optionName: "trendLineThickness"): number;
	igSparkline(optionLiteral: 'option', optionName: "trendLineThickness", optionValue: number): void;
	igSparkline(optionLiteral: 'option', optionName: "normalRangeMinimum"): number;
	igSparkline(optionLiteral: 'option', optionName: "normalRangeMinimum", optionValue: number): void;
	igSparkline(optionLiteral: 'option', optionName: "normalRangeMaximum"): number;
	igSparkline(optionLiteral: 'option', optionName: "normalRangeMaximum", optionValue: number): void;
	igSparkline(optionLiteral: 'option', optionName: "displayType"): any;
	igSparkline(optionLiteral: 'option', optionName: "displayType", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "unknownValuePlotting"): any;
	igSparkline(optionLiteral: 'option', optionName: "unknownValuePlotting", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "verticalAxisLabel"): any;
	igSparkline(optionLiteral: 'option', optionName: "verticalAxisLabel", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "horizontalAxisLabel"): any;
	igSparkline(optionLiteral: 'option', optionName: "horizontalAxisLabel", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "formatLabel"): any;
	igSparkline(optionLiteral: 'option', optionName: "formatLabel", optionValue: any): void;
	igSparkline(optionLiteral: 'option', optionName: "dataBinding"): DataBindingEvent;
	igSparkline(optionLiteral: 'option', optionName: "dataBinding", optionValue: DataBindingEvent): void;
	igSparkline(optionLiteral: 'option', optionName: "dataBound"): DataBoundEvent;
	igSparkline(optionLiteral: 'option', optionName: "dataBound", optionValue: DataBoundEvent): void;
	igSparkline(options: IgSparkline): JQuery;
	igSparkline(optionLiteral: 'option', optionName: string): any;
	igSparkline(optionLiteral: 'option', options: IgSparkline): JQuery;
	igSparkline(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igSparkline(methodName: string, ...methodParams: any[]): any;
}
interface IgSplitButton {
	items?: IgSplitButtonItem[];
	defaultItemName?: string;
	swapDefaultEnabled?: boolean;
	click?: ClickEvent;
	expanded?: ExpandedEvent;
	expanding?: ExpandingEvent;
	collapsed?: CollapsedEvent;
	collapsing?: CollapsingEvent;
}
interface IgSplitButtonMethods {
	switchToButton(button: Object): void;
	widget(): void;
	toggle(e: Object): void;
	collapse(e: Object): void;
	expand(e: Object): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igSplitButton"):IgSplitButtonMethods;
}

interface JQuery {
	igSplitButton(methodName: "switchToButton", button: Object): void;
	igSplitButton(methodName: "widget"): void;
	igSplitButton(methodName: "toggle", e: Object): void;
	igSplitButton(methodName: "collapse", e: Object): void;
	igSplitButton(methodName: "expand", e: Object): void;
	igSplitButton(methodName: "destroy"): void;
	igSplitButton(optionLiteral: 'option', optionName: "items"): IgSplitButtonItem[];
	igSplitButton(optionLiteral: 'option', optionName: "items", optionValue: IgSplitButtonItem[]): void;
	igSplitButton(optionLiteral: 'option', optionName: "defaultItemName"): string;
	igSplitButton(optionLiteral: 'option', optionName: "defaultItemName", optionValue: string): void;
	igSplitButton(optionLiteral: 'option', optionName: "swapDefaultEnabled"): boolean;
	igSplitButton(optionLiteral: 'option', optionName: "swapDefaultEnabled", optionValue: boolean): void;
	igSplitButton(optionLiteral: 'option', optionName: "click"): ClickEvent;
	igSplitButton(optionLiteral: 'option', optionName: "click", optionValue: ClickEvent): void;
	igSplitButton(optionLiteral: 'option', optionName: "expanded"): ExpandedEvent;
	igSplitButton(optionLiteral: 'option', optionName: "expanded", optionValue: ExpandedEvent): void;
	igSplitButton(optionLiteral: 'option', optionName: "expanding"): ExpandingEvent;
	igSplitButton(optionLiteral: 'option', optionName: "expanding", optionValue: ExpandingEvent): void;
	igSplitButton(optionLiteral: 'option', optionName: "collapsed"): CollapsedEvent;
	igSplitButton(optionLiteral: 'option', optionName: "collapsed", optionValue: CollapsedEvent): void;
	igSplitButton(optionLiteral: 'option', optionName: "collapsing"): CollapsingEvent;
	igSplitButton(optionLiteral: 'option', optionName: "collapsing", optionValue: CollapsingEvent): void;
	igSplitButton(options: IgSplitButton): JQuery;
	igSplitButton(optionLiteral: 'option', optionName: string): any;
	igSplitButton(optionLiteral: 'option', options: IgSplitButton): JQuery;
	igSplitButton(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igSplitButton(methodName: string, ...methodParams: any[]): any;
}
interface IgSplitterPanels {
}

interface ResizeStartedEvent {
	(event: Event, ui: ResizeStartedEventUIParam): void;
}

interface ResizeStartedEventUIParam {
	owner?: any;
}

interface ResizingEvent {
	(event: Event, ui: ResizingEventUIParam): void;
}

interface ResizingEventUIParam {
	owner?: any;
}

interface ResizeEndedEvent {
	(event: Event, ui: ResizeEndedEventUIParam): void;
}

interface ResizeEndedEventUIParam {
	owner?: any;
}

interface LayoutRefreshingEvent {
	(event: Event, ui: LayoutRefreshingEventUIParam): void;
}

interface LayoutRefreshingEventUIParam {
	owner?: any;
}

interface LayoutRefreshedEvent {
	(event: Event, ui: LayoutRefreshedEventUIParam): void;
}

interface LayoutRefreshedEventUIParam {
	owner?: any;
}

interface IgSplitter {
	width?: any;
	height?: any;
	orientation?: any;
	panels?: IgSplitterPanels;
	dragDelta?: number;
	resizeOtherSplitters?: boolean;
	collapsed?: CollapsedEvent;
	expanded?: ExpandedEvent;
	resizeStarted?: ResizeStartedEvent;
	resizing?: ResizingEvent;
	resizeEnded?: ResizeEndedEvent;
	layoutRefreshing?: LayoutRefreshingEvent;
	layoutRefreshed?: LayoutRefreshedEvent;
}
interface IgSplitterMethods {
	widget(): Object;
	expandAt(index: Object): void;
	collapseAt(index: Object): void;
	firstPanel(): Object;
	secondPanel(): Object;
	refreshLayout(): void;
	setFirstPanelSize(size: Object): void;
	setSecondPanelSize(size: Object): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igSplitter"):IgSplitterMethods;
}

interface JQuery {
	igSplitter(methodName: "widget"): Object;
	igSplitter(methodName: "expandAt", index: Object): void;
	igSplitter(methodName: "collapseAt", index: Object): void;
	igSplitter(methodName: "firstPanel"): Object;
	igSplitter(methodName: "secondPanel"): Object;
	igSplitter(methodName: "refreshLayout"): void;
	igSplitter(methodName: "setFirstPanelSize", size: Object): void;
	igSplitter(methodName: "setSecondPanelSize", size: Object): void;
	igSplitter(methodName: "destroy"): void;
	igSplitter(optionLiteral: 'option', optionName: "width"): any;
	igSplitter(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igSplitter(optionLiteral: 'option', optionName: "height"): any;
	igSplitter(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igSplitter(optionLiteral: 'option', optionName: "orientation"): any;
	igSplitter(optionLiteral: 'option', optionName: "orientation", optionValue: any): void;
	igSplitter(optionLiteral: 'option', optionName: "panels"): IgSplitterPanels;
	igSplitter(optionLiteral: 'option', optionName: "panels", optionValue: IgSplitterPanels): void;
	igSplitter(optionLiteral: 'option', optionName: "dragDelta"): number;
	igSplitter(optionLiteral: 'option', optionName: "dragDelta", optionValue: number): void;
	igSplitter(optionLiteral: 'option', optionName: "resizeOtherSplitters"): boolean;
	igSplitter(optionLiteral: 'option', optionName: "resizeOtherSplitters", optionValue: boolean): void;
	igSplitter(optionLiteral: 'option', optionName: "collapsed"): CollapsedEvent;
	igSplitter(optionLiteral: 'option', optionName: "collapsed", optionValue: CollapsedEvent): void;
	igSplitter(optionLiteral: 'option', optionName: "expanded"): ExpandedEvent;
	igSplitter(optionLiteral: 'option', optionName: "expanded", optionValue: ExpandedEvent): void;
	igSplitter(optionLiteral: 'option', optionName: "resizeStarted"): ResizeStartedEvent;
	igSplitter(optionLiteral: 'option', optionName: "resizeStarted", optionValue: ResizeStartedEvent): void;
	igSplitter(optionLiteral: 'option', optionName: "resizing"): ResizingEvent;
	igSplitter(optionLiteral: 'option', optionName: "resizing", optionValue: ResizingEvent): void;
	igSplitter(optionLiteral: 'option', optionName: "resizeEnded"): ResizeEndedEvent;
	igSplitter(optionLiteral: 'option', optionName: "resizeEnded", optionValue: ResizeEndedEvent): void;
	igSplitter(optionLiteral: 'option', optionName: "layoutRefreshing"): LayoutRefreshingEvent;
	igSplitter(optionLiteral: 'option', optionName: "layoutRefreshing", optionValue: LayoutRefreshingEvent): void;
	igSplitter(optionLiteral: 'option', optionName: "layoutRefreshed"): LayoutRefreshedEvent;
	igSplitter(optionLiteral: 'option', optionName: "layoutRefreshed", optionValue: LayoutRefreshedEvent): void;
	igSplitter(options: IgSplitter): JQuery;
	igSplitter(optionLiteral: 'option', optionName: string): any;
	igSplitter(optionLiteral: 'option', options: IgSplitter): JQuery;
	igSplitter(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igSplitter(methodName: string, ...methodParams: any[]): any;
}
interface TileRenderingEvent {
	(event: Event, ui: TileRenderingEventUIParam): void;
}

interface TileRenderingEventUIParam {
	owner?: any;
	tile?: any;
}

interface TileRenderedEvent {
	(event: Event, ui: TileRenderedEventUIParam): void;
}

interface TileRenderedEventUIParam {
	owner?: any;
	tile?: any;
}

interface TileMaximizingEvent {
	(event: Event, ui: TileMaximizingEventUIParam): void;
}

interface TileMaximizingEventUIParam {
	owner?: any;
	tile?: any;
	minimizingTile?: any;
}

interface TileMaximizedEvent {
	(event: Event, ui: TileMaximizedEventUIParam): void;
}

interface TileMaximizedEventUIParam {
	owner?: any;
	tile?: any;
}

interface TileMinimizingEvent {
	(event: Event, ui: TileMinimizingEventUIParam): void;
}

interface TileMinimizingEventUIParam {
	owner?: any;
	tile?: any;
	maximizingTile?: any;
}

interface TileMinimizedEvent {
	(event: Event, ui: TileMinimizedEventUIParam): void;
}

interface TileMinimizedEventUIParam {
	owner?: any;
	tile?: any;
}

interface IgTileManager {
	width?: any;
	height?: any;
	columnWidth?: any;
	columnHeight?: any;
	cols?: any;
	rows?: any;
	marginLeft?: number;
	marginTop?: number;
	rearrangeItems?: boolean;
	items?: any;
	dataSource?: any;
	minimizedState?: any;
	maximizedState?: any;
	maximizedTileIndex?: any;
	rightPanelCols?: any;
	rightPanelTilesWidth?: any;
	rightPanelTilesHeight?: any;
	showRightPanelScroll?: boolean;
	showSplitter?: boolean;
	preventMaximizingSelector?: string;
	animationDuration?: number;
	dataSourceUrl?: string;
	responseDataKey?: any;
	responseDataType?: string;
	dataSourceType?: string;
	requestType?: string;
	responseContentType?: string;
	dataBinding?: DataBindingEvent;
	dataBound?: DataBoundEvent;
	rendering?: RenderingEvent;
	rendered?: RenderedEvent;
	tileRendering?: TileRenderingEvent;
	tileRendered?: TileRenderedEvent;
	tileMaximizing?: TileMaximizingEvent;
	tileMaximized?: TileMaximizedEvent;
	tileMinimizing?: TileMinimizingEvent;
	tileMinimized?: TileMinimizedEvent;
}
interface IgTileManagerMethods {
	maximize($tileToMaximize: Object, animDuration?: number, event?: Object): void;
	minimize(animDuration?: number, event?: Object): void;
	maximizedTile(): void;
	minimizedTiles(): void;
	splitter(): void;
	layoutManager(): Object;
	reflow(forceReflow?: Object, animationDuration?: number, event?: Object): void;
	widget(): Object;
	dataBind(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igTileManager"):IgTileManagerMethods;
}

interface JQuery {
	igTileManager(methodName: "maximize", $tileToMaximize: Object, animDuration?: number, event?: Object): void;
	igTileManager(methodName: "minimize", animDuration?: number, event?: Object): void;
	igTileManager(methodName: "maximizedTile"): void;
	igTileManager(methodName: "minimizedTiles"): void;
	igTileManager(methodName: "splitter"): void;
	igTileManager(methodName: "layoutManager"): Object;
	igTileManager(methodName: "reflow", forceReflow?: Object, animationDuration?: number, event?: Object): void;
	igTileManager(methodName: "widget"): Object;
	igTileManager(methodName: "dataBind"): void;
	igTileManager(methodName: "destroy"): void;
	igTileManager(optionLiteral: 'option', optionName: "width"): any;
	igTileManager(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "height"): any;
	igTileManager(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "columnWidth"): any;
	igTileManager(optionLiteral: 'option', optionName: "columnWidth", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "columnHeight"): any;
	igTileManager(optionLiteral: 'option', optionName: "columnHeight", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "cols"): any;
	igTileManager(optionLiteral: 'option', optionName: "cols", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "rows"): any;
	igTileManager(optionLiteral: 'option', optionName: "rows", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "marginLeft"): number;
	igTileManager(optionLiteral: 'option', optionName: "marginLeft", optionValue: number): void;
	igTileManager(optionLiteral: 'option', optionName: "marginTop"): number;
	igTileManager(optionLiteral: 'option', optionName: "marginTop", optionValue: number): void;
	igTileManager(optionLiteral: 'option', optionName: "rearrangeItems"): boolean;
	igTileManager(optionLiteral: 'option', optionName: "rearrangeItems", optionValue: boolean): void;
	igTileManager(optionLiteral: 'option', optionName: "items"): any;
	igTileManager(optionLiteral: 'option', optionName: "items", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "dataSource"): any;
	igTileManager(optionLiteral: 'option', optionName: "dataSource", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "minimizedState"): any;
	igTileManager(optionLiteral: 'option', optionName: "minimizedState", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "maximizedState"): any;
	igTileManager(optionLiteral: 'option', optionName: "maximizedState", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "maximizedTileIndex"): any;
	igTileManager(optionLiteral: 'option', optionName: "maximizedTileIndex", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "rightPanelCols"): any;
	igTileManager(optionLiteral: 'option', optionName: "rightPanelCols", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "rightPanelTilesWidth"): any;
	igTileManager(optionLiteral: 'option', optionName: "rightPanelTilesWidth", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "rightPanelTilesHeight"): any;
	igTileManager(optionLiteral: 'option', optionName: "rightPanelTilesHeight", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "showRightPanelScroll"): boolean;
	igTileManager(optionLiteral: 'option', optionName: "showRightPanelScroll", optionValue: boolean): void;
	igTileManager(optionLiteral: 'option', optionName: "showSplitter"): boolean;
	igTileManager(optionLiteral: 'option', optionName: "showSplitter", optionValue: boolean): void;
	igTileManager(optionLiteral: 'option', optionName: "preventMaximizingSelector"): string;
	igTileManager(optionLiteral: 'option', optionName: "preventMaximizingSelector", optionValue: string): void;
	igTileManager(optionLiteral: 'option', optionName: "animationDuration"): number;
	igTileManager(optionLiteral: 'option', optionName: "animationDuration", optionValue: number): void;
	igTileManager(optionLiteral: 'option', optionName: "dataSourceUrl"): string;
	igTileManager(optionLiteral: 'option', optionName: "dataSourceUrl", optionValue: string): void;
	igTileManager(optionLiteral: 'option', optionName: "responseDataKey"): any;
	igTileManager(optionLiteral: 'option', optionName: "responseDataKey", optionValue: any): void;
	igTileManager(optionLiteral: 'option', optionName: "responseDataType"): string;
	igTileManager(optionLiteral: 'option', optionName: "responseDataType", optionValue: string): void;
	igTileManager(optionLiteral: 'option', optionName: "dataSourceType"): string;
	igTileManager(optionLiteral: 'option', optionName: "dataSourceType", optionValue: string): void;
	igTileManager(optionLiteral: 'option', optionName: "requestType"): string;
	igTileManager(optionLiteral: 'option', optionName: "requestType", optionValue: string): void;
	igTileManager(optionLiteral: 'option', optionName: "responseContentType"): string;
	igTileManager(optionLiteral: 'option', optionName: "responseContentType", optionValue: string): void;
	igTileManager(optionLiteral: 'option', optionName: "dataBinding"): DataBindingEvent;
	igTileManager(optionLiteral: 'option', optionName: "dataBinding", optionValue: DataBindingEvent): void;
	igTileManager(optionLiteral: 'option', optionName: "dataBound"): DataBoundEvent;
	igTileManager(optionLiteral: 'option', optionName: "dataBound", optionValue: DataBoundEvent): void;
	igTileManager(optionLiteral: 'option', optionName: "rendering"): RenderingEvent;
	igTileManager(optionLiteral: 'option', optionName: "rendering", optionValue: RenderingEvent): void;
	igTileManager(optionLiteral: 'option', optionName: "rendered"): RenderedEvent;
	igTileManager(optionLiteral: 'option', optionName: "rendered", optionValue: RenderedEvent): void;
	igTileManager(optionLiteral: 'option', optionName: "tileRendering"): TileRenderingEvent;
	igTileManager(optionLiteral: 'option', optionName: "tileRendering", optionValue: TileRenderingEvent): void;
	igTileManager(optionLiteral: 'option', optionName: "tileRendered"): TileRenderedEvent;
	igTileManager(optionLiteral: 'option', optionName: "tileRendered", optionValue: TileRenderedEvent): void;
	igTileManager(optionLiteral: 'option', optionName: "tileMaximizing"): TileMaximizingEvent;
	igTileManager(optionLiteral: 'option', optionName: "tileMaximizing", optionValue: TileMaximizingEvent): void;
	igTileManager(optionLiteral: 'option', optionName: "tileMaximized"): TileMaximizedEvent;
	igTileManager(optionLiteral: 'option', optionName: "tileMaximized", optionValue: TileMaximizedEvent): void;
	igTileManager(optionLiteral: 'option', optionName: "tileMinimizing"): TileMinimizingEvent;
	igTileManager(optionLiteral: 'option', optionName: "tileMinimizing", optionValue: TileMinimizingEvent): void;
	igTileManager(optionLiteral: 'option', optionName: "tileMinimized"): TileMinimizedEvent;
	igTileManager(optionLiteral: 'option', optionName: "tileMinimized", optionValue: TileMinimizedEvent): void;
	igTileManager(options: IgTileManager): JQuery;
	igTileManager(optionLiteral: 'option', optionName: string): any;
	igTileManager(optionLiteral: 'option', options: IgTileManager): JQuery;
	igTileManager(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTileManager(methodName: string, ...methodParams: any[]): any;
}
interface ToolbarButtonClickEvent {
	(event: Event, ui: ToolbarButtonClickEventUIParam): void;
}

interface ToolbarButtonClickEventUIParam {
}

interface ToolbarComboOpeningEvent {
	(event: Event, ui: ToolbarComboOpeningEventUIParam): void;
}

interface ToolbarComboOpeningEventUIParam {
}

interface ToolbarComboSelectedEvent {
	(event: Event, ui: ToolbarComboSelectedEventUIParam): void;
}

interface ToolbarComboSelectedEventUIParam {
}

interface ToolbarCustomItemClickEvent {
	(event: Event, ui: ToolbarCustomItemClickEventUIParam): void;
}

interface ToolbarCustomItemClickEventUIParam {
}

interface ItemRemovedEvent {
	(event: Event, ui: ItemRemovedEventUIParam): void;
}

interface ItemRemovedEventUIParam {
}

interface ItemAddedEvent {
	(event: Event, ui: ItemAddedEventUIParam): void;
}

interface ItemAddedEventUIParam {
}

interface ItemDisableEvent {
	(event: Event, ui: ItemDisableEventUIParam): void;
}

interface ItemDisableEventUIParam {
}

interface ItemEnabledEvent {
	(event: Event, ui: ItemEnabledEventUIParam): void;
}

interface ItemEnabledEventUIParam {
}

interface WindowResizedEvent {
	(event: Event, ui: WindowResizedEventUIParam): void;
}

interface WindowResizedEventUIParam {
}

interface IgToolbar {
	height?: any;
	width?: any;
	allowCollapsing?: boolean;
	collapseButtonIcon?: string;
	expandButtonIcon?: string;
	name?: string;
	displayName?: string;
	items?: any[];
	isExpanded?: boolean;
	toolbarButtonClick?: ToolbarButtonClickEvent;
	toolbarComboOpening?: ToolbarComboOpeningEvent;
	toolbarComboSelected?: ToolbarComboSelectedEvent;
	toolbarCustomItemClick?: ToolbarCustomItemClickEvent;
	itemRemoved?: ItemRemovedEvent;
	itemAdded?: ItemAddedEvent;
	collapsing?: CollapsingEvent;
	collapsed?: CollapsedEvent;
	expanding?: ExpandingEvent;
	expanded?: ExpandedEvent;
	itemDisable?: ItemDisableEvent;
	itemEnabled?: ItemEnabledEvent;
	windowResized?: WindowResizedEvent;
}
interface IgToolbarMethods {
	widget(): void;
	getItem(index: Object): Object;
	addItem(item: Object): void;
	removeItem(index: Object): Object;
	disableItem(index: Object, disabled: Object): void;
	activateItem(index: Object, activated: Object): void;
	deactivateAll(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igToolbar"):IgToolbarMethods;
}

interface JQuery {
	igToolbar(methodName: "widget"): void;
	igToolbar(methodName: "getItem", index: Object): Object;
	igToolbar(methodName: "addItem", item: Object): void;
	igToolbar(methodName: "removeItem", index: Object): Object;
	igToolbar(methodName: "disableItem", index: Object, disabled: Object): void;
	igToolbar(methodName: "activateItem", index: Object, activated: Object): void;
	igToolbar(methodName: "deactivateAll"): void;
	igToolbar(methodName: "destroy"): void;
	igToolbar(optionLiteral: 'option', optionName: "height"): any;
	igToolbar(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igToolbar(optionLiteral: 'option', optionName: "width"): any;
	igToolbar(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igToolbar(optionLiteral: 'option', optionName: "allowCollapsing"): boolean;
	igToolbar(optionLiteral: 'option', optionName: "allowCollapsing", optionValue: boolean): void;
	igToolbar(optionLiteral: 'option', optionName: "collapseButtonIcon"): string;
	igToolbar(optionLiteral: 'option', optionName: "collapseButtonIcon", optionValue: string): void;
	igToolbar(optionLiteral: 'option', optionName: "expandButtonIcon"): string;
	igToolbar(optionLiteral: 'option', optionName: "expandButtonIcon", optionValue: string): void;
	igToolbar(optionLiteral: 'option', optionName: "name"): string;
	igToolbar(optionLiteral: 'option', optionName: "name", optionValue: string): void;
	igToolbar(optionLiteral: 'option', optionName: "displayName"): string;
	igToolbar(optionLiteral: 'option', optionName: "displayName", optionValue: string): void;
	igToolbar(optionLiteral: 'option', optionName: "items"): any[];
	igToolbar(optionLiteral: 'option', optionName: "items", optionValue: any[]): void;
	igToolbar(optionLiteral: 'option', optionName: "isExpanded"): boolean;
	igToolbar(optionLiteral: 'option', optionName: "isExpanded", optionValue: boolean): void;
	igToolbar(optionLiteral: 'option', optionName: "toolbarButtonClick"): ToolbarButtonClickEvent;
	igToolbar(optionLiteral: 'option', optionName: "toolbarButtonClick", optionValue: ToolbarButtonClickEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "toolbarComboOpening"): ToolbarComboOpeningEvent;
	igToolbar(optionLiteral: 'option', optionName: "toolbarComboOpening", optionValue: ToolbarComboOpeningEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "toolbarComboSelected"): ToolbarComboSelectedEvent;
	igToolbar(optionLiteral: 'option', optionName: "toolbarComboSelected", optionValue: ToolbarComboSelectedEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "toolbarCustomItemClick"): ToolbarCustomItemClickEvent;
	igToolbar(optionLiteral: 'option', optionName: "toolbarCustomItemClick", optionValue: ToolbarCustomItemClickEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "itemRemoved"): ItemRemovedEvent;
	igToolbar(optionLiteral: 'option', optionName: "itemRemoved", optionValue: ItemRemovedEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "itemAdded"): ItemAddedEvent;
	igToolbar(optionLiteral: 'option', optionName: "itemAdded", optionValue: ItemAddedEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "collapsing"): CollapsingEvent;
	igToolbar(optionLiteral: 'option', optionName: "collapsing", optionValue: CollapsingEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "collapsed"): CollapsedEvent;
	igToolbar(optionLiteral: 'option', optionName: "collapsed", optionValue: CollapsedEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "expanding"): ExpandingEvent;
	igToolbar(optionLiteral: 'option', optionName: "expanding", optionValue: ExpandingEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "expanded"): ExpandedEvent;
	igToolbar(optionLiteral: 'option', optionName: "expanded", optionValue: ExpandedEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "itemDisable"): ItemDisableEvent;
	igToolbar(optionLiteral: 'option', optionName: "itemDisable", optionValue: ItemDisableEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "itemEnabled"): ItemEnabledEvent;
	igToolbar(optionLiteral: 'option', optionName: "itemEnabled", optionValue: ItemEnabledEvent): void;
	igToolbar(optionLiteral: 'option', optionName: "windowResized"): WindowResizedEvent;
	igToolbar(optionLiteral: 'option', optionName: "windowResized", optionValue: WindowResizedEvent): void;
	igToolbar(options: IgToolbar): JQuery;
	igToolbar(optionLiteral: 'option', optionName: string): any;
	igToolbar(optionLiteral: 'option', options: IgToolbar): JQuery;
	igToolbar(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igToolbar(methodName: string, ...methodParams: any[]): any;
}
interface ActivatingEvent {
	(event: Event, ui: ActivatingEventUIParam): void;
}

interface ActivatingEventUIParam {
	owner?: any;
}

interface ActivatedEvent {
	(event: Event, ui: ActivatedEventUIParam): void;
}

interface ActivatedEventUIParam {
	owner?: any;
}

interface DeactivatingEvent {
	(event: Event, ui: DeactivatingEventUIParam): void;
}

interface DeactivatingEventUIParam {
	owner?: any;
}

interface DeactivatedEvent {
	(event: Event, ui: DeactivatedEventUIParam): void;
}

interface DeactivatedEventUIParam {
	owner?: any;
}

interface IgToolbarButton {
	allowToggling?: boolean;
	isSelected?: boolean;
	activating?: ActivatingEvent;
	activated?: ActivatedEvent;
	deactivating?: DeactivatingEvent;
	deactivated?: DeactivatedEvent;
}
interface IgToolbarButtonMethods {
	toggle(): void;
	activate(event: Object): void;
	deactivate(event: Object): void;
	widget(): Object;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igToolbarButton"):IgToolbarButtonMethods;
}

interface JQuery {
	igToolbarButton(methodName: "toggle"): void;
	igToolbarButton(methodName: "activate", event: Object): void;
	igToolbarButton(methodName: "deactivate", event: Object): void;
	igToolbarButton(methodName: "widget"): Object;
	igToolbarButton(methodName: "destroy"): void;
	igToolbarButton(optionLiteral: 'option', optionName: "allowToggling"): boolean;
	igToolbarButton(optionLiteral: 'option', optionName: "allowToggling", optionValue: boolean): void;
	igToolbarButton(optionLiteral: 'option', optionName: "isSelected"): boolean;
	igToolbarButton(optionLiteral: 'option', optionName: "isSelected", optionValue: boolean): void;
	igToolbarButton(optionLiteral: 'option', optionName: "activating"): ActivatingEvent;
	igToolbarButton(optionLiteral: 'option', optionName: "activating", optionValue: ActivatingEvent): void;
	igToolbarButton(optionLiteral: 'option', optionName: "activated"): ActivatedEvent;
	igToolbarButton(optionLiteral: 'option', optionName: "activated", optionValue: ActivatedEvent): void;
	igToolbarButton(optionLiteral: 'option', optionName: "deactivating"): DeactivatingEvent;
	igToolbarButton(optionLiteral: 'option', optionName: "deactivating", optionValue: DeactivatingEvent): void;
	igToolbarButton(optionLiteral: 'option', optionName: "deactivated"): DeactivatedEvent;
	igToolbarButton(optionLiteral: 'option', optionName: "deactivated", optionValue: DeactivatedEvent): void;
	igToolbarButton(options: IgToolbarButton): JQuery;
	igToolbarButton(optionLiteral: 'option', optionName: string): any;
	igToolbarButton(optionLiteral: 'option', options: IgToolbarButton): JQuery;
	igToolbarButton(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igToolbarButton(methodName: string, ...methodParams: any[]): any;
}
interface IgTreeBindingsBindings {
}

interface IgTreeBindings {
	textKey?: string;
	textXPath?: string;
	valueKey?: string;
	valueXPath?: string;
	imageUrlKey?: string;
	imageUrlXPath?: string;
	navigateUrlKey?: string;
	navigateUrlXPath?: string;
	targetKey?: string;
	expandedKey?: string;
	primaryKey?: string;
	nodeContentTemplate?: string;
	childDataProperty?: string;
	childDataXPath?: string;
	searchFieldXPath?: string;
	bindings?: IgTreeBindingsBindings;
}

interface IgTreeDragAndDropSettings {
	allowDrop?: boolean;
	dragAndDropMode?: any;
	dragOpacity?: number;
	revert?: boolean;
	revertDuration?: number;
	zIndex?: number;
	dragStartDelay?: number;
	expandOnDragOver?: boolean;
	expandDelay?: number;
	helper?: any;
	customDropValidation?: Function;
	containment?: any;
	invalidMoveToMarkup?: string;
	moveToMarkup?: string;
	moveBetweenMarkup?: string;
	moveAfterMarkup?: string;
	moveBeforeMarkup?: string;
	copyToMarkup?: string;
	copyBetweenMarkup?: string;
	copyAfterMarkup?: string;
	copyBeforeMarkup?: string;
}

interface NodeCheckstateChangingEvent {
	(event: Event, ui: NodeCheckstateChangingEventUIParam): void;
}

interface NodeCheckstateChangingEventUIParam {
	owner?: any;
	node?: any;
	currentState?: any;
	newState?: any;
	currentCheckedNodes?: any;
}

interface NodeCheckstateChangedEvent {
	(event: Event, ui: NodeCheckstateChangedEventUIParam): void;
}

interface NodeCheckstateChangedEventUIParam {
	owner?: any;
	node?: any;
	newState?: any;
	newCheckedNodes?: any;
	newPartiallyCheckedNodes?: any;
}

interface NodePopulatingEvent {
	(event: Event, ui: NodePopulatingEventUIParam): void;
}

interface NodePopulatingEventUIParam {
	path?: any;
	element?: any;
	data?: any;
	binding?: any;
}

interface NodePopulatedEvent {
	(event: Event, ui: NodePopulatedEventUIParam): void;
}

interface NodePopulatedEventUIParam {
	path?: any;
	element?: any;
	data?: any;
	binding?: any;
}

interface NodeCollapsingEvent {
	(event: Event, ui: NodeCollapsingEventUIParam): void;
}

interface NodeCollapsingEventUIParam {
	owner?: any;
	node?: any;
}

interface NodeCollapsedEvent {
	(event: Event, ui: NodeCollapsedEventUIParam): void;
}

interface NodeCollapsedEventUIParam {
	owner?: any;
	node?: any;
}

interface NodeExpandingEvent {
	(event: Event, ui: NodeExpandingEventUIParam): void;
}

interface NodeExpandingEventUIParam {
	owner?: any;
	node?: any;
}

interface NodeExpandedEvent {
	(event: Event, ui: NodeExpandedEventUIParam): void;
}

interface NodeExpandedEventUIParam {
	owner?: any;
	node?: any;
}

interface NodeClickEvent {
	(event: Event, ui: NodeClickEventUIParam): void;
}

interface NodeClickEventUIParam {
	owner?: any;
	node?: any;
}

interface NodeDoubleClickEvent {
	(event: Event, ui: NodeDoubleClickEventUIParam): void;
}

interface NodeDoubleClickEventUIParam {
	path?: any;
	element?: any;
	data?: any;
	binding?: any;
}

interface NodeDroppingEvent {
	(event: Event, ui: NodeDroppingEventUIParam): void;
}

interface NodeDroppingEventUIParam {
	binding?: any;
	data?: any;
	draggable?: any;
	element?: any;
	helper?: any;
	offset?: any;
	path?: any;
	position?: any;
}

interface NodeDroppedEvent {
	(event: Event, ui: NodeDroppedEventUIParam): void;
}

interface NodeDroppedEventUIParam {
	binding?: any;
	data?: any;
	draggable?: any;
	element?: any;
	helper?: any;
	offset?: any;
	path?: any;
	position?: any;
}

interface IgTree {
	width?: any;
	height?: any;
	checkboxMode?: any;
	singleBranchExpand?: boolean;
	hotTracking?: boolean;
	parentNodeImageUrl?: string;
	parentNodeImageClass?: string;
	parentNodeImageTooltip?: string;
	leafNodeImageUrl?: string;
	leafNodeImageClass?: string;
	leafNodeImageTooltip?: string;
	animationDuration?: number;
	pathSeparator?: string;
	dataSource?: any;
	dataSourceUrl?: string;
	dataSourceType?: string;
	responseDataKey?: string;
	responseDataType?: string;
	requestType?: string;
	responseContentType?: string;
	initialExpandDepth?: number;
	loadOnDemand?: boolean;
	bindings?: IgTreeBindings;
	defaultNodeTarget?: string;
	dragAndDrop?: boolean;
	updateUrl?: string;
	dragAndDropSettings?: IgTreeDragAndDropSettings;
	dataBinding?: DataBindingEvent;
	dataBound?: DataBoundEvent;
	rendering?: RenderingEvent;
	rendered?: RenderedEvent;
	selectionChanging?: SelectionChangingEvent;
	selectionChanged?: SelectionChangedEvent;
	nodeCheckstateChanging?: NodeCheckstateChangingEvent;
	nodeCheckstateChanged?: NodeCheckstateChangedEvent;
	nodePopulating?: NodePopulatingEvent;
	nodePopulated?: NodePopulatedEvent;
	nodeCollapsing?: NodeCollapsingEvent;
	nodeCollapsed?: NodeCollapsedEvent;
	nodeExpanding?: NodeExpandingEvent;
	nodeExpanded?: NodeExpandedEvent;
	nodeClick?: NodeClickEvent;
	nodeDoubleClick?: NodeDoubleClickEvent;
	dragStart?: DragStartEvent;
	drag?: DragEvent;
	dragStop?: DragStopEvent;
	nodeDropping?: NodeDroppingEvent;
	nodeDropped?: NodeDroppedEvent;
}
interface IgTreeMethods {
	widget(): Object;
	dataBind(): void;
	toggleCheckstate(node: Object, event?: Object): void;
	toggle(node: Object, event?: Object): void;
	expandToNode(node: Object, toSelect?: boolean): void;
	expand(node: Object): void;
	collapse(node: Object): void;
	parentNode(node: Object): Object;
	nodeByPath(nodePath: string): Object;
	nodesByValue(value: string): Object;
	checkedNodes(): any[];
	uncheckedNodes(): any[];
	partiallyCheckedNodes(): any[];
	select(node: Object, event?: Object): void;
	deselect(node: Object): void;
	clearSelection(): void;
	selectedNode(): Object;
	findNodesByText(text: string, parent?: Object): Object;
	findImmediateNodesByText(text: string, parent?: Object): Object;
	nodeByIndex(index: number, parent?: Object): Object;
	nodeFromElement(element: Object): Object;
	children(parent: Object): Object;
	childrenByPath(path: string): Object;
	isSelected(node: Object): boolean;
	isExpanded(node: Object): boolean;
	isChecked(node: Object): boolean;
	checkState(node: Object): string;
	addNode(node: Object, parent?: Object, nodeIndex?: number): void;
	removeAt(path: string): void;
	removeNodesByValue(value: string): void;
	applyChangesToNode(element: Object, data: Object): void;
	transactionLog(): Object;
	nodeDataFor(path: string): Object;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igTree"):IgTreeMethods;
}

interface JQuery {
	igTree(methodName: "widget"): Object;
	igTree(methodName: "dataBind"): void;
	igTree(methodName: "toggleCheckstate", node: Object, event?: Object): void;
	igTree(methodName: "toggle", node: Object, event?: Object): void;
	igTree(methodName: "expandToNode", node: Object, toSelect?: boolean): void;
	igTree(methodName: "expand", node: Object): void;
	igTree(methodName: "collapse", node: Object): void;
	igTree(methodName: "parentNode", node: Object): Object;
	igTree(methodName: "nodeByPath", nodePath: string): Object;
	igTree(methodName: "nodesByValue", value: string): Object;
	igTree(methodName: "checkedNodes"): any[];
	igTree(methodName: "uncheckedNodes"): any[];
	igTree(methodName: "partiallyCheckedNodes"): any[];
	igTree(methodName: "select", node: Object, event?: Object): void;
	igTree(methodName: "deselect", node: Object): void;
	igTree(methodName: "clearSelection"): void;
	igTree(methodName: "selectedNode"): Object;
	igTree(methodName: "findNodesByText", text: string, parent?: Object): Object;
	igTree(methodName: "findImmediateNodesByText", text: string, parent?: Object): Object;
	igTree(methodName: "nodeByIndex", index: number, parent?: Object): Object;
	igTree(methodName: "nodeFromElement", element: Object): Object;
	igTree(methodName: "children", parent: Object): Object;
	igTree(methodName: "childrenByPath", path: string): Object;
	igTree(methodName: "isSelected", node: Object): boolean;
	igTree(methodName: "isExpanded", node: Object): boolean;
	igTree(methodName: "isChecked", node: Object): boolean;
	igTree(methodName: "checkState", node: Object): string;
	igTree(methodName: "addNode", node: Object, parent?: Object, nodeIndex?: number): void;
	igTree(methodName: "removeAt", path: string): void;
	igTree(methodName: "removeNodesByValue", value: string): void;
	igTree(methodName: "applyChangesToNode", element: Object, data: Object): void;
	igTree(methodName: "transactionLog"): Object;
	igTree(methodName: "nodeDataFor", path: string): Object;
	igTree(methodName: "destroy"): void;
	igTree(optionLiteral: 'option', optionName: "width"): any;
	igTree(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igTree(optionLiteral: 'option', optionName: "height"): any;
	igTree(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igTree(optionLiteral: 'option', optionName: "checkboxMode"): any;
	igTree(optionLiteral: 'option', optionName: "checkboxMode", optionValue: any): void;
	igTree(optionLiteral: 'option', optionName: "singleBranchExpand"): boolean;
	igTree(optionLiteral: 'option', optionName: "singleBranchExpand", optionValue: boolean): void;
	igTree(optionLiteral: 'option', optionName: "hotTracking"): boolean;
	igTree(optionLiteral: 'option', optionName: "hotTracking", optionValue: boolean): void;
	igTree(optionLiteral: 'option', optionName: "parentNodeImageUrl"): string;
	igTree(optionLiteral: 'option', optionName: "parentNodeImageUrl", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "parentNodeImageClass"): string;
	igTree(optionLiteral: 'option', optionName: "parentNodeImageClass", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "parentNodeImageTooltip"): string;
	igTree(optionLiteral: 'option', optionName: "parentNodeImageTooltip", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "leafNodeImageUrl"): string;
	igTree(optionLiteral: 'option', optionName: "leafNodeImageUrl", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "leafNodeImageClass"): string;
	igTree(optionLiteral: 'option', optionName: "leafNodeImageClass", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "leafNodeImageTooltip"): string;
	igTree(optionLiteral: 'option', optionName: "leafNodeImageTooltip", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "animationDuration"): number;
	igTree(optionLiteral: 'option', optionName: "animationDuration", optionValue: number): void;
	igTree(optionLiteral: 'option', optionName: "pathSeparator"): string;
	igTree(optionLiteral: 'option', optionName: "pathSeparator", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "dataSource"): any;
	igTree(optionLiteral: 'option', optionName: "dataSource", optionValue: any): void;
	igTree(optionLiteral: 'option', optionName: "dataSourceUrl"): string;
	igTree(optionLiteral: 'option', optionName: "dataSourceUrl", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "dataSourceType"): string;
	igTree(optionLiteral: 'option', optionName: "dataSourceType", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "responseDataKey"): string;
	igTree(optionLiteral: 'option', optionName: "responseDataKey", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "responseDataType"): string;
	igTree(optionLiteral: 'option', optionName: "responseDataType", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "requestType"): string;
	igTree(optionLiteral: 'option', optionName: "requestType", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "responseContentType"): string;
	igTree(optionLiteral: 'option', optionName: "responseContentType", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "initialExpandDepth"): number;
	igTree(optionLiteral: 'option', optionName: "initialExpandDepth", optionValue: number): void;
	igTree(optionLiteral: 'option', optionName: "loadOnDemand"): boolean;
	igTree(optionLiteral: 'option', optionName: "loadOnDemand", optionValue: boolean): void;
	igTree(optionLiteral: 'option', optionName: "bindings"): IgTreeBindings;
	igTree(optionLiteral: 'option', optionName: "bindings", optionValue: IgTreeBindings): void;
	igTree(optionLiteral: 'option', optionName: "defaultNodeTarget"): string;
	igTree(optionLiteral: 'option', optionName: "defaultNodeTarget", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "dragAndDrop"): boolean;
	igTree(optionLiteral: 'option', optionName: "dragAndDrop", optionValue: boolean): void;
	igTree(optionLiteral: 'option', optionName: "updateUrl"): string;
	igTree(optionLiteral: 'option', optionName: "updateUrl", optionValue: string): void;
	igTree(optionLiteral: 'option', optionName: "dragAndDropSettings"): IgTreeDragAndDropSettings;
	igTree(optionLiteral: 'option', optionName: "dragAndDropSettings", optionValue: IgTreeDragAndDropSettings): void;
	igTree(optionLiteral: 'option', optionName: "dataBinding"): DataBindingEvent;
	igTree(optionLiteral: 'option', optionName: "dataBinding", optionValue: DataBindingEvent): void;
	igTree(optionLiteral: 'option', optionName: "dataBound"): DataBoundEvent;
	igTree(optionLiteral: 'option', optionName: "dataBound", optionValue: DataBoundEvent): void;
	igTree(optionLiteral: 'option', optionName: "rendering"): RenderingEvent;
	igTree(optionLiteral: 'option', optionName: "rendering", optionValue: RenderingEvent): void;
	igTree(optionLiteral: 'option', optionName: "rendered"): RenderedEvent;
	igTree(optionLiteral: 'option', optionName: "rendered", optionValue: RenderedEvent): void;
	igTree(optionLiteral: 'option', optionName: "selectionChanging"): SelectionChangingEvent;
	igTree(optionLiteral: 'option', optionName: "selectionChanging", optionValue: SelectionChangingEvent): void;
	igTree(optionLiteral: 'option', optionName: "selectionChanged"): SelectionChangedEvent;
	igTree(optionLiteral: 'option', optionName: "selectionChanged", optionValue: SelectionChangedEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodeCheckstateChanging"): NodeCheckstateChangingEvent;
	igTree(optionLiteral: 'option', optionName: "nodeCheckstateChanging", optionValue: NodeCheckstateChangingEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodeCheckstateChanged"): NodeCheckstateChangedEvent;
	igTree(optionLiteral: 'option', optionName: "nodeCheckstateChanged", optionValue: NodeCheckstateChangedEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodePopulating"): NodePopulatingEvent;
	igTree(optionLiteral: 'option', optionName: "nodePopulating", optionValue: NodePopulatingEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodePopulated"): NodePopulatedEvent;
	igTree(optionLiteral: 'option', optionName: "nodePopulated", optionValue: NodePopulatedEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodeCollapsing"): NodeCollapsingEvent;
	igTree(optionLiteral: 'option', optionName: "nodeCollapsing", optionValue: NodeCollapsingEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodeCollapsed"): NodeCollapsedEvent;
	igTree(optionLiteral: 'option', optionName: "nodeCollapsed", optionValue: NodeCollapsedEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodeExpanding"): NodeExpandingEvent;
	igTree(optionLiteral: 'option', optionName: "nodeExpanding", optionValue: NodeExpandingEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodeExpanded"): NodeExpandedEvent;
	igTree(optionLiteral: 'option', optionName: "nodeExpanded", optionValue: NodeExpandedEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodeClick"): NodeClickEvent;
	igTree(optionLiteral: 'option', optionName: "nodeClick", optionValue: NodeClickEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodeDoubleClick"): NodeDoubleClickEvent;
	igTree(optionLiteral: 'option', optionName: "nodeDoubleClick", optionValue: NodeDoubleClickEvent): void;
	igTree(optionLiteral: 'option', optionName: "dragStart"): DragStartEvent;
	igTree(optionLiteral: 'option', optionName: "dragStart", optionValue: DragStartEvent): void;
	igTree(optionLiteral: 'option', optionName: "drag"): DragEvent;
	igTree(optionLiteral: 'option', optionName: "drag", optionValue: DragEvent): void;
	igTree(optionLiteral: 'option', optionName: "dragStop"): DragStopEvent;
	igTree(optionLiteral: 'option', optionName: "dragStop", optionValue: DragStopEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodeDropping"): NodeDroppingEvent;
	igTree(optionLiteral: 'option', optionName: "nodeDropping", optionValue: NodeDroppingEvent): void;
	igTree(optionLiteral: 'option', optionName: "nodeDropped"): NodeDroppedEvent;
	igTree(optionLiteral: 'option', optionName: "nodeDropped", optionValue: NodeDroppedEvent): void;
	igTree(options: IgTree): JQuery;
	igTree(optionLiteral: 'option', optionName: string): any;
	igTree(optionLiteral: 'option', options: IgTree): JQuery;
	igTree(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTree(methodName: string, ...methodParams: any[]): any;
}
interface IgTreeGridColumnFixing {
	headerFixButtonText?: string;
	headerUnfixButtonText?: string;
	showFixButtons?: boolean;
	syncRowHeights?: boolean;
	scrollDelta?: number;
	fixingDirection?: any;
	columnSettings?: IgGridColumnFixingColumnSetting[];
	featureChooserTextFixedColumn?: string;
	featureChooserTextUnfixedColumn?: string;
	minimalVisibleAreaWidth?: any;
	fixNondataColumns?: boolean;
	populateDataRowsAttributes?: boolean;
	columnFixing?: ColumnFixingEvent;
	columnFixed?: ColumnFixedEvent;
	columnUnfixing?: ColumnUnfixingEvent;
	columnUnfixed?: ColumnUnfixedEvent;
	columnFixingRefused?: ColumnFixingRefusedEvent;
	columnUnfixingRefused?: ColumnUnfixingRefusedEvent;
}
interface IgTreeGridColumnFixingMethods {
	destroy(): void;
	unfixColumn(colIdentifier: Object, isGroupHeader?: boolean, target?: string, after?: boolean): Object;
	checkAndSyncHeights(): void;
	unfixDataSkippedColumns(): void;
	unfixAllColumns(): void;
	checkFixingAllowed(columns: any[]): boolean;
	checkUnfixingAllowed(columns: any[]): boolean;
	fixColumn(colIdentifier: Object, isGroupHeader?: boolean, target?: string, after?: boolean): Object;
	fixDataSkippedColumns(): void;
	syncRowsHeights($trs: any[], $anotherRows: any[]): void;
	getWidthOfFixedColumns(fCols?: any[], excludeNonDataColumns?: boolean, includeHidden?: boolean): number;
}
interface JQuery {
	data(propertyName: "igTreeGridColumnFixing"):IgTreeGridColumnFixingMethods;
}

interface JQuery {
	igTreeGridColumnFixing(methodName: "destroy"): void;
	igTreeGridColumnFixing(methodName: "unfixColumn", colIdentifier: Object, isGroupHeader?: boolean, target?: string, after?: boolean): Object;
	igTreeGridColumnFixing(methodName: "checkAndSyncHeights"): void;
	igTreeGridColumnFixing(methodName: "unfixDataSkippedColumns"): void;
	igTreeGridColumnFixing(methodName: "unfixAllColumns"): void;
	igTreeGridColumnFixing(methodName: "checkFixingAllowed", columns: any[]): boolean;
	igTreeGridColumnFixing(methodName: "checkUnfixingAllowed", columns: any[]): boolean;
	igTreeGridColumnFixing(methodName: "fixColumn", colIdentifier: Object, isGroupHeader?: boolean, target?: string, after?: boolean): Object;
	igTreeGridColumnFixing(methodName: "fixDataSkippedColumns"): void;
	igTreeGridColumnFixing(methodName: "syncRowsHeights", $trs: any[], $anotherRows: any[]): void;
	igTreeGridColumnFixing(methodName: "getWidthOfFixedColumns", fCols?: any[], excludeNonDataColumns?: boolean, includeHidden?: boolean): number;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "headerFixButtonText"): string;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "headerFixButtonText", optionValue: string): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "headerUnfixButtonText"): string;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "headerUnfixButtonText", optionValue: string): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "showFixButtons"): boolean;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "showFixButtons", optionValue: boolean): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "syncRowHeights"): boolean;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "syncRowHeights", optionValue: boolean): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "scrollDelta"): number;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "scrollDelta", optionValue: number): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "fixingDirection"): any;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "fixingDirection", optionValue: any): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnSettings"): IgGridColumnFixingColumnSetting[];
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridColumnFixingColumnSetting[]): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "featureChooserTextFixedColumn"): string;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "featureChooserTextFixedColumn", optionValue: string): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "featureChooserTextUnfixedColumn"): string;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "featureChooserTextUnfixedColumn", optionValue: string): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "minimalVisibleAreaWidth"): any;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "minimalVisibleAreaWidth", optionValue: any): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "fixNondataColumns"): boolean;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "fixNondataColumns", optionValue: boolean): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "populateDataRowsAttributes"): boolean;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "populateDataRowsAttributes", optionValue: boolean): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnFixing"): ColumnFixingEvent;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnFixing", optionValue: ColumnFixingEvent): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnFixed"): ColumnFixedEvent;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnFixed", optionValue: ColumnFixedEvent): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixing"): ColumnUnfixingEvent;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixing", optionValue: ColumnUnfixingEvent): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixed"): ColumnUnfixedEvent;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixed", optionValue: ColumnUnfixedEvent): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnFixingRefused"): ColumnFixingRefusedEvent;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnFixingRefused", optionValue: ColumnFixingRefusedEvent): void;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixingRefused"): ColumnUnfixingRefusedEvent;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: "columnUnfixingRefused", optionValue: ColumnUnfixingRefusedEvent): void;
	igTreeGridColumnFixing(options: IgTreeGridColumnFixing): JQuery;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: string): any;
	igTreeGridColumnFixing(optionLiteral: 'option', options: IgTreeGridColumnFixing): JQuery;
	igTreeGridColumnFixing(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTreeGridColumnFixing(methodName: string, ...methodParams: any[]): any;
}
interface IgTreeGridFiltering {
	fromLevel?: number;
	toLevel?: number;
	displayMode?: any;
	matchFiltering?: string;
	caseSensitive?: boolean;
	filterSummaryAlwaysVisible?: boolean;
	renderFC?: boolean;
	filterSummaryTemplate?: string;
	filterDropDownAnimations?: any;
	filterDropDownAnimationDuration?: number;
	filterDropDownWidth?: any;
	filterDropDownHeight?: any;
	filterExprUrlKey?: string;
	filterDropDownItemIcons?: any;
	columnSettings?: IgGridFilteringColumnSetting[];
	type?: any;
	filterDelay?: number;
	mode?: any;
	advancedModeEditorsVisible?: boolean;
	advancedModeHeaderButtonLocation?: any;
	filterDialogWidth?: any;
	filterDialogHeight?: any;
	filterDialogFilterDropDownDefaultWidth?: any;
	filterDialogExprInputDefaultWidth?: any;
	filterDialogColumnDropDownDefaultWidth?: any;
	renderFilterButton?: boolean;
	filterButtonLocation?: any;
	nullTexts?: IgGridFilteringNullTexts;
	labels?: IgGridFilteringLabels;
	tooltipTemplate?: string;
	filterDialogAddConditionTemplate?: string;
	filterDialogAddConditionDropDownTemplate?: string;
	filterDialogFilterTemplate?: string;
	filterDialogFilterConditionTemplate?: string;
	filterDialogAddButtonWidth?: any;
	filterDialogOkCancelButtonWidth?: any;
	filterDialogMaxFilterCount?: number;
	filterDialogContainment?: string;
	showEmptyConditions?: boolean;
	showNullConditions?: boolean;
	featureChooserText?: string;
	featureChooserTextHide?: string;
	featureChooserTextAdvancedFilter?: string;
	persist?: boolean;
	inherit?: boolean;
	dataFiltering?: DataFilteringEvent;
	dataFiltered?: DataFilteredEvent;
	dropDownOpening?: DropDownOpeningEvent;
	dropDownOpened?: DropDownOpenedEvent;
	dropDownClosing?: DropDownClosingEvent;
	dropDownClosed?: DropDownClosedEvent;
	filterDialogOpening?: FilterDialogOpeningEvent;
	filterDialogOpened?: FilterDialogOpenedEvent;
	filterDialogMoving?: FilterDialogMovingEvent;
	filterDialogFilterAdding?: FilterDialogFilterAddingEvent;
	filterDialogFilterAdded?: FilterDialogFilterAddedEvent;
	filterDialogClosing?: FilterDialogClosingEvent;
	filterDialogClosed?: FilterDialogClosedEvent;
	filterDialogContentsRendering?: FilterDialogContentsRenderingEvent;
	filterDialogContentsRendered?: FilterDialogContentsRenderedEvent;
	filterDialogFiltering?: FilterDialogFilteringEvent;
}
interface IgTreeGridFilteringMethods {
	getFilteringMatchesCount(): number;
	destroy(): void;
	toggleFilterRowByFeatureChooser(event: string): void;
	filter(expressions: any[], updateUI?: boolean, addedFromAdvanced?: boolean): void;
	requiresFilteringExpression(filterCondition: string): boolean;
}
interface JQuery {
	data(propertyName: "igTreeGridFiltering"):IgTreeGridFilteringMethods;
}

interface JQuery {
	igTreeGridFiltering(methodName: "getFilteringMatchesCount"): number;
	igTreeGridFiltering(methodName: "destroy"): void;
	igTreeGridFiltering(methodName: "toggleFilterRowByFeatureChooser", event: string): void;
	igTreeGridFiltering(methodName: "filter", expressions: any[], updateUI?: boolean, addedFromAdvanced?: boolean): void;
	igTreeGridFiltering(methodName: "requiresFilteringExpression", filterCondition: string): boolean;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "fromLevel"): number;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "fromLevel", optionValue: number): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "toLevel"): number;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "toLevel", optionValue: number): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "displayMode"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "displayMode", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "matchFiltering"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "matchFiltering", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "caseSensitive"): boolean;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "caseSensitive", optionValue: boolean): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterSummaryAlwaysVisible"): boolean;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterSummaryAlwaysVisible", optionValue: boolean): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "renderFC"): boolean;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "renderFC", optionValue: boolean): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterSummaryTemplate"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterSummaryTemplate", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDropDownAnimations"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDropDownAnimations", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDropDownAnimationDuration"): number;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDropDownAnimationDuration", optionValue: number): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDropDownWidth"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDropDownWidth", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDropDownHeight"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDropDownHeight", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterExprUrlKey"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterExprUrlKey", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDropDownItemIcons"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDropDownItemIcons", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "columnSettings"): IgGridFilteringColumnSetting[];
	igTreeGridFiltering(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridFilteringColumnSetting[]): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "type"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDelay"): number;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDelay", optionValue: number): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "mode"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "mode", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "advancedModeEditorsVisible"): boolean;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "advancedModeEditorsVisible", optionValue: boolean): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "advancedModeHeaderButtonLocation"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "advancedModeHeaderButtonLocation", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogWidth"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogWidth", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogHeight"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogHeight", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterDropDownDefaultWidth"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterDropDownDefaultWidth", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogExprInputDefaultWidth"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogExprInputDefaultWidth", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogColumnDropDownDefaultWidth"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogColumnDropDownDefaultWidth", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "renderFilterButton"): boolean;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "renderFilterButton", optionValue: boolean): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterButtonLocation"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterButtonLocation", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "nullTexts"): IgGridFilteringNullTexts;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "nullTexts", optionValue: IgGridFilteringNullTexts): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "labels"): IgGridFilteringLabels;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "labels", optionValue: IgGridFilteringLabels): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "tooltipTemplate"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "tooltipTemplate", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddConditionTemplate"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddConditionTemplate", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddConditionDropDownTemplate"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddConditionDropDownTemplate", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterTemplate"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterTemplate", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterConditionTemplate"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterConditionTemplate", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddButtonWidth"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogAddButtonWidth", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogOkCancelButtonWidth"): any;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogOkCancelButtonWidth", optionValue: any): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogMaxFilterCount"): number;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogMaxFilterCount", optionValue: number): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogContainment"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogContainment", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "showEmptyConditions"): boolean;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "showEmptyConditions", optionValue: boolean): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "showNullConditions"): boolean;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "showNullConditions", optionValue: boolean): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "featureChooserText"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "featureChooserText", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "featureChooserTextHide"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "featureChooserTextHide", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "featureChooserTextAdvancedFilter"): string;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "featureChooserTextAdvancedFilter", optionValue: string): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "persist"): boolean;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "persist", optionValue: boolean): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "inherit"): boolean;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dataFiltering"): DataFilteringEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dataFiltering", optionValue: DataFilteringEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dataFiltered"): DataFilteredEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dataFiltered", optionValue: DataFilteredEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dropDownOpening"): DropDownOpeningEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dropDownOpening", optionValue: DropDownOpeningEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dropDownOpened"): DropDownOpenedEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dropDownOpened", optionValue: DropDownOpenedEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dropDownClosing"): DropDownClosingEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dropDownClosing", optionValue: DropDownClosingEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dropDownClosed"): DropDownClosedEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "dropDownClosed", optionValue: DropDownClosedEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogOpening"): FilterDialogOpeningEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogOpening", optionValue: FilterDialogOpeningEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogOpened"): FilterDialogOpenedEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogOpened", optionValue: FilterDialogOpenedEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogMoving"): FilterDialogMovingEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogMoving", optionValue: FilterDialogMovingEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterAdding"): FilterDialogFilterAddingEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterAdding", optionValue: FilterDialogFilterAddingEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterAdded"): FilterDialogFilterAddedEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFilterAdded", optionValue: FilterDialogFilterAddedEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogClosing"): FilterDialogClosingEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogClosing", optionValue: FilterDialogClosingEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogClosed"): FilterDialogClosedEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogClosed", optionValue: FilterDialogClosedEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogContentsRendering"): FilterDialogContentsRenderingEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogContentsRendering", optionValue: FilterDialogContentsRenderingEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogContentsRendered"): FilterDialogContentsRenderedEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogContentsRendered", optionValue: FilterDialogContentsRenderedEvent): void;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFiltering"): FilterDialogFilteringEvent;
	igTreeGridFiltering(optionLiteral: 'option', optionName: "filterDialogFiltering", optionValue: FilterDialogFilteringEvent): void;
	igTreeGridFiltering(options: IgTreeGridFiltering): JQuery;
	igTreeGridFiltering(optionLiteral: 'option', optionName: string): any;
	igTreeGridFiltering(optionLiteral: 'option', options: IgTreeGridFiltering): JQuery;
	igTreeGridFiltering(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTreeGridFiltering(methodName: string, ...methodParams: any[]): any;
}
interface IgTreeGridHiding {
	columnSettings?: IgGridHidingColumnSetting[];
	hiddenColumnIndicatorHeaderWidth?: number;
	columnChooserContainment?: string;
	columnChooserWidth?: number;
	columnChooserHeight?: number;
	dropDownAnimationDuration?: number;
	columnChooserCaptionText?: string;
	columnChooserDisplayText?: string;
	hiddenColumnIndicatorTooltipText?: string;
	columnHideText?: string;
	columnChooserShowText?: string;
	columnChooserHideText?: string;
	columnChooserHideOnClick?: boolean;
	columnChooserResetButtonLabel?: string;
	columnChooserAnimationDuration?: number;
	columnChooserButtonApplyText?: string;
	columnChooserButtonCancelText?: string;
	inherit?: boolean;
	columnHiding?: ColumnHidingEvent;
	columnHidingRefused?: ColumnHidingRefusedEvent;
	columnShowingRefused?: ColumnShowingRefusedEvent;
	multiColumnHiding?: MultiColumnHidingEvent;
	columnHidden?: ColumnHiddenEvent;
	columnShowing?: ColumnShowingEvent;
	columnShown?: ColumnShownEvent;
	columnChooserOpening?: ColumnChooserOpeningEvent;
	columnChooserOpened?: ColumnChooserOpenedEvent;
	columnChooserMoving?: ColumnChooserMovingEvent;
	columnChooserClosing?: ColumnChooserClosingEvent;
	columnChooserClosed?: ColumnChooserClosedEvent;
	columnChooserContentsRendering?: ColumnChooserContentsRenderingEvent;
	columnChooserContentsRendered?: ColumnChooserContentsRenderedEvent;
	columnChooserButtonApplyClick?: ColumnChooserButtonApplyClickEvent;
	columnChooserButtonResetClick?: ColumnChooserButtonResetClickEvent;
}
interface IgTreeGridHidingMethods {
	destroy(): void;
	showColumnChooser(): void;
	hideColumnChooser(): void;
	showColumn(column: Object, isMultiColumnHeader?: boolean, callback?: Function): void;
	hideColumn(column: Object, isMultiColumnHeader?: boolean, callback?: Function): void;
	hideMultiColumns(columns: any[], callback?: Function): void;
	showMultiColumns(columns: any[], callback?: Function): void;
	isToRenderButtonReset(): void;
	resetHidingColumnChooser(): void;
	renderColumnChooserResetButton(): void;
	removeColumnChooserResetButton(): void;
}
interface JQuery {
	data(propertyName: "igTreeGridHiding"):IgTreeGridHidingMethods;
}

interface JQuery {
	igTreeGridHiding(methodName: "destroy"): void;
	igTreeGridHiding(methodName: "showColumnChooser"): void;
	igTreeGridHiding(methodName: "hideColumnChooser"): void;
	igTreeGridHiding(methodName: "showColumn", column: Object, isMultiColumnHeader?: boolean, callback?: Function): void;
	igTreeGridHiding(methodName: "hideColumn", column: Object, isMultiColumnHeader?: boolean, callback?: Function): void;
	igTreeGridHiding(methodName: "hideMultiColumns", columns: any[], callback?: Function): void;
	igTreeGridHiding(methodName: "showMultiColumns", columns: any[], callback?: Function): void;
	igTreeGridHiding(methodName: "isToRenderButtonReset"): void;
	igTreeGridHiding(methodName: "resetHidingColumnChooser"): void;
	igTreeGridHiding(methodName: "renderColumnChooserResetButton"): void;
	igTreeGridHiding(methodName: "removeColumnChooserResetButton"): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnSettings"): IgGridHidingColumnSetting[];
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridHidingColumnSetting[]): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "hiddenColumnIndicatorHeaderWidth"): number;
	igTreeGridHiding(optionLiteral: 'option', optionName: "hiddenColumnIndicatorHeaderWidth", optionValue: number): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserContainment"): string;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserContainment", optionValue: string): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserWidth"): number;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserWidth", optionValue: number): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserHeight"): number;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserHeight", optionValue: number): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "dropDownAnimationDuration"): number;
	igTreeGridHiding(optionLiteral: 'option', optionName: "dropDownAnimationDuration", optionValue: number): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserCaptionText"): string;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserCaptionText", optionValue: string): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserDisplayText"): string;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserDisplayText", optionValue: string): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "hiddenColumnIndicatorTooltipText"): string;
	igTreeGridHiding(optionLiteral: 'option', optionName: "hiddenColumnIndicatorTooltipText", optionValue: string): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnHideText"): string;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnHideText", optionValue: string): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserShowText"): string;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserShowText", optionValue: string): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserHideText"): string;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserHideText", optionValue: string): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserHideOnClick"): boolean;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserHideOnClick", optionValue: boolean): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserResetButtonLabel"): string;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserResetButtonLabel", optionValue: string): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserAnimationDuration"): number;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserAnimationDuration", optionValue: number): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonApplyText"): string;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonApplyText", optionValue: string): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonCancelText"): string;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonCancelText", optionValue: string): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "inherit"): boolean;
	igTreeGridHiding(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnHiding"): ColumnHidingEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnHiding", optionValue: ColumnHidingEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnHidingRefused"): ColumnHidingRefusedEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnHidingRefused", optionValue: ColumnHidingRefusedEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnShowingRefused"): ColumnShowingRefusedEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnShowingRefused", optionValue: ColumnShowingRefusedEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "multiColumnHiding"): MultiColumnHidingEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "multiColumnHiding", optionValue: MultiColumnHidingEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnHidden"): ColumnHiddenEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnHidden", optionValue: ColumnHiddenEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnShowing"): ColumnShowingEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnShowing", optionValue: ColumnShowingEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnShown"): ColumnShownEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnShown", optionValue: ColumnShownEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserOpening"): ColumnChooserOpeningEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserOpening", optionValue: ColumnChooserOpeningEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserOpened"): ColumnChooserOpenedEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserOpened", optionValue: ColumnChooserOpenedEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserMoving"): ColumnChooserMovingEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserMoving", optionValue: ColumnChooserMovingEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserClosing"): ColumnChooserClosingEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserClosing", optionValue: ColumnChooserClosingEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserClosed"): ColumnChooserClosedEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserClosed", optionValue: ColumnChooserClosedEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserContentsRendering"): ColumnChooserContentsRenderingEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserContentsRendering", optionValue: ColumnChooserContentsRenderingEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserContentsRendered"): ColumnChooserContentsRenderedEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserContentsRendered", optionValue: ColumnChooserContentsRenderedEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonApplyClick"): ColumnChooserButtonApplyClickEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonApplyClick", optionValue: ColumnChooserButtonApplyClickEvent): void;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonResetClick"): ColumnChooserButtonResetClickEvent;
	igTreeGridHiding(optionLiteral: 'option', optionName: "columnChooserButtonResetClick", optionValue: ColumnChooserButtonResetClickEvent): void;
	igTreeGridHiding(options: IgTreeGridHiding): JQuery;
	igTreeGridHiding(optionLiteral: 'option', optionName: string): any;
	igTreeGridHiding(optionLiteral: 'option', options: IgTreeGridHiding): JQuery;
	igTreeGridHiding(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTreeGridHiding(methodName: string, ...methodParams: any[]): any;
}
interface IgTreeGridDataSourceSettings {
	propertyExpanded?: string;
	propertyDataLevel?: string;
}

interface IgTreeGrid {
	indentation?: string;
	initialIndentationLevel?: number;
	showExpansionIndicator?: boolean;
	expandTooltipText?: string;
	collapseTooltipText?: string;
	foreignKey?: string;
	initialExpandDepth?: number;
	foreignKeyRootValue?: number;
	renderExpansionIndicatorColumn?: boolean;
	renderFirstDataCellFunction?: any;
	childDataKey?: string;
	renderExpansionCellFunction?: any;
	enableRemoteLoadOnDemand?: boolean;
	dataSourceSettings?: IgTreeGridDataSourceSettings;
	rowExpanding?: RowExpandingEvent;
	rowExpanded?: RowExpandedEvent;
	rowCollapsing?: RowCollapsingEvent;
	rowCollapsed?: RowCollapsedEvent;
}
interface IgTreeGridMethods {
	dataBind(): void;
	toggleRow(row: Object, callback?: Function): void;
	expandRow(row: Object, callback?: Function): void;
	collapseRow(row: Object, callback?: Function): void;
	destroy(): Object;
}
interface JQuery {
	data(propertyName: "igTreeGrid"):IgTreeGridMethods;
}

interface JQuery {
	igTreeGrid(methodName: "dataBind"): void;
	igTreeGrid(methodName: "toggleRow", row: Object, callback?: Function): void;
	igTreeGrid(methodName: "expandRow", row: Object, callback?: Function): void;
	igTreeGrid(methodName: "collapseRow", row: Object, callback?: Function): void;
	igTreeGrid(methodName: "destroy"): Object;
	igTreeGrid(optionLiteral: 'option', optionName: "indentation"): string;
	igTreeGrid(optionLiteral: 'option', optionName: "indentation", optionValue: string): void;
	igTreeGrid(optionLiteral: 'option', optionName: "initialIndentationLevel"): number;
	igTreeGrid(optionLiteral: 'option', optionName: "initialIndentationLevel", optionValue: number): void;
	igTreeGrid(optionLiteral: 'option', optionName: "showExpansionIndicator"): boolean;
	igTreeGrid(optionLiteral: 'option', optionName: "showExpansionIndicator", optionValue: boolean): void;
	igTreeGrid(optionLiteral: 'option', optionName: "expandTooltipText"): string;
	igTreeGrid(optionLiteral: 'option', optionName: "expandTooltipText", optionValue: string): void;
	igTreeGrid(optionLiteral: 'option', optionName: "collapseTooltipText"): string;
	igTreeGrid(optionLiteral: 'option', optionName: "collapseTooltipText", optionValue: string): void;
	igTreeGrid(optionLiteral: 'option', optionName: "foreignKey"): string;
	igTreeGrid(optionLiteral: 'option', optionName: "foreignKey", optionValue: string): void;
	igTreeGrid(optionLiteral: 'option', optionName: "initialExpandDepth"): number;
	igTreeGrid(optionLiteral: 'option', optionName: "initialExpandDepth", optionValue: number): void;
	igTreeGrid(optionLiteral: 'option', optionName: "foreignKeyRootValue"): number;
	igTreeGrid(optionLiteral: 'option', optionName: "foreignKeyRootValue", optionValue: number): void;
	igTreeGrid(optionLiteral: 'option', optionName: "renderExpansionIndicatorColumn"): boolean;
	igTreeGrid(optionLiteral: 'option', optionName: "renderExpansionIndicatorColumn", optionValue: boolean): void;
	igTreeGrid(optionLiteral: 'option', optionName: "renderFirstDataCellFunction"): any;
	igTreeGrid(optionLiteral: 'option', optionName: "renderFirstDataCellFunction", optionValue: any): void;
	igTreeGrid(optionLiteral: 'option', optionName: "childDataKey"): string;
	igTreeGrid(optionLiteral: 'option', optionName: "childDataKey", optionValue: string): void;
	igTreeGrid(optionLiteral: 'option', optionName: "renderExpansionCellFunction"): any;
	igTreeGrid(optionLiteral: 'option', optionName: "renderExpansionCellFunction", optionValue: any): void;
	igTreeGrid(optionLiteral: 'option', optionName: "enableRemoteLoadOnDemand"): boolean;
	igTreeGrid(optionLiteral: 'option', optionName: "enableRemoteLoadOnDemand", optionValue: boolean): void;
	igTreeGrid(optionLiteral: 'option', optionName: "dataSourceSettings"): IgTreeGridDataSourceSettings;
	igTreeGrid(optionLiteral: 'option', optionName: "dataSourceSettings", optionValue: IgTreeGridDataSourceSettings): void;
	igTreeGrid(optionLiteral: 'option', optionName: "rowExpanding"): RowExpandingEvent;
	igTreeGrid(optionLiteral: 'option', optionName: "rowExpanding", optionValue: RowExpandingEvent): void;
	igTreeGrid(optionLiteral: 'option', optionName: "rowExpanded"): RowExpandedEvent;
	igTreeGrid(optionLiteral: 'option', optionName: "rowExpanded", optionValue: RowExpandedEvent): void;
	igTreeGrid(optionLiteral: 'option', optionName: "rowCollapsing"): RowCollapsingEvent;
	igTreeGrid(optionLiteral: 'option', optionName: "rowCollapsing", optionValue: RowCollapsingEvent): void;
	igTreeGrid(optionLiteral: 'option', optionName: "rowCollapsed"): RowCollapsedEvent;
	igTreeGrid(optionLiteral: 'option', optionName: "rowCollapsed", optionValue: RowCollapsedEvent): void;
	igTreeGrid(options: IgTreeGrid): JQuery;
	igTreeGrid(optionLiteral: 'option', optionName: string): any;
	igTreeGrid(optionLiteral: 'option', options: IgTreeGrid): JQuery;
	igTreeGrid(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTreeGrid(methodName: string, ...methodParams: any[]): any;
}
interface IgTreeGridMultiColumnHeaders {
	inherit?: boolean;
}
interface IgTreeGridMultiColumnHeadersMethods {
	destroy(): void;
	getMultiColumnHeaders(): any[];
}
interface JQuery {
	data(propertyName: "igTreeGridMultiColumnHeaders"):IgTreeGridMultiColumnHeadersMethods;
}

interface JQuery {
	igTreeGridMultiColumnHeaders(methodName: "destroy"): void;
	igTreeGridMultiColumnHeaders(methodName: "getMultiColumnHeaders"): any[];
	igTreeGridMultiColumnHeaders(optionLiteral: 'option', optionName: "inherit"): boolean;
	igTreeGridMultiColumnHeaders(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igTreeGridMultiColumnHeaders(options: IgTreeGridMultiColumnHeaders): JQuery;
	igTreeGridMultiColumnHeaders(optionLiteral: 'option', optionName: string): any;
	igTreeGridMultiColumnHeaders(optionLiteral: 'option', options: IgTreeGridMultiColumnHeaders): JQuery;
	igTreeGridMultiColumnHeaders(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTreeGridMultiColumnHeaders(methodName: string, ...methodParams: any[]): any;
}
interface IgTreeGridPaging {
	mode?: any;
	pageSize?: number;
	recordCountKey?: string;
	pageSizeUrlKey?: string;
	pageIndexUrlKey?: string;
	currentPageIndex?: number;
	type?: any;
	showPageSizeDropDown?: boolean;
	pageSizeDropDownLabel?: string;
	pageSizeDropDownTrailingLabel?: string;
	pageSizeDropDownLocation?: any;
	showPagerRecordsLabel?: boolean;
	pagerRecordsLabelTemplate?: string;
	nextPageLabelText?: string;
	prevPageLabelText?: string;
	firstPageLabelText?: string;
	lastPageLabelText?: string;
	showFirstLastPages?: boolean;
	showPrevNextPages?: boolean;
	currentPageDropDownLeadingLabel?: string;
	currentPageDropDownTrailingLabel?: string;
	currentPageDropDownTooltip?: string;
	pageSizeDropDownTooltip?: string;
	pagerRecordsLabelTooltip?: string;
	prevPageTooltip?: string;
	nextPageTooltip?: string;
	firstPageTooltip?: string;
	lastPageTooltip?: string;
	pageTooltipFormat?: string;
	pageSizeList?: any[];
	pageCountLimit?: number;
	visiblePageCount?: number;
	defaultDropDownWidth?: number;
	delayOnPageChanged?: number;
	persist?: boolean;
	inherit?: boolean;
	pageIndexChanging?: PageIndexChangingEvent;
	pageIndexChanged?: PageIndexChangedEvent;
	pageSizeChanging?: PageSizeChangingEvent;
	pageSizeChanged?: PageSizeChangedEvent;
	pagerRendering?: PagerRenderingEvent;
	pagerRendered?: PagerRenderedEvent;
}
interface IgTreeGridPagingMethods {
	destroy(): void;
	pageIndex(index?: number): number;
	pageSize(size?: number): number;
}
interface JQuery {
	data(propertyName: "igTreeGridPaging"):IgTreeGridPagingMethods;
}

interface JQuery {
	igTreeGridPaging(methodName: "destroy"): void;
	igTreeGridPaging(methodName: "pageIndex", index?: number): number;
	igTreeGridPaging(methodName: "pageSize", size?: number): number;
	igTreeGridPaging(optionLiteral: 'option', optionName: "mode"): any;
	igTreeGridPaging(optionLiteral: 'option', optionName: "mode", optionValue: any): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSize"): number;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSize", optionValue: number): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "recordCountKey"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "recordCountKey", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeUrlKey"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeUrlKey", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageIndexUrlKey"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageIndexUrlKey", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "currentPageIndex"): number;
	igTreeGridPaging(optionLiteral: 'option', optionName: "currentPageIndex", optionValue: number): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "type"): any;
	igTreeGridPaging(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "showPageSizeDropDown"): boolean;
	igTreeGridPaging(optionLiteral: 'option', optionName: "showPageSizeDropDown", optionValue: boolean): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownLabel"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownLabel", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownTrailingLabel"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownTrailingLabel", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownLocation"): any;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownLocation", optionValue: any): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "showPagerRecordsLabel"): boolean;
	igTreeGridPaging(optionLiteral: 'option', optionName: "showPagerRecordsLabel", optionValue: boolean): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pagerRecordsLabelTemplate"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pagerRecordsLabelTemplate", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "nextPageLabelText"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "nextPageLabelText", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "prevPageLabelText"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "prevPageLabelText", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "firstPageLabelText"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "firstPageLabelText", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "lastPageLabelText"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "lastPageLabelText", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "showFirstLastPages"): boolean;
	igTreeGridPaging(optionLiteral: 'option', optionName: "showFirstLastPages", optionValue: boolean): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "showPrevNextPages"): boolean;
	igTreeGridPaging(optionLiteral: 'option', optionName: "showPrevNextPages", optionValue: boolean): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownLeadingLabel"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownLeadingLabel", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownTrailingLabel"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownTrailingLabel", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownTooltip"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "currentPageDropDownTooltip", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownTooltip"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeDropDownTooltip", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pagerRecordsLabelTooltip"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pagerRecordsLabelTooltip", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "prevPageTooltip"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "prevPageTooltip", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "nextPageTooltip"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "nextPageTooltip", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "firstPageTooltip"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "firstPageTooltip", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "lastPageTooltip"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "lastPageTooltip", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageTooltipFormat"): string;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageTooltipFormat", optionValue: string): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeList"): any[];
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeList", optionValue: any[]): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageCountLimit"): number;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageCountLimit", optionValue: number): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "visiblePageCount"): number;
	igTreeGridPaging(optionLiteral: 'option', optionName: "visiblePageCount", optionValue: number): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "defaultDropDownWidth"): number;
	igTreeGridPaging(optionLiteral: 'option', optionName: "defaultDropDownWidth", optionValue: number): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "delayOnPageChanged"): number;
	igTreeGridPaging(optionLiteral: 'option', optionName: "delayOnPageChanged", optionValue: number): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "persist"): boolean;
	igTreeGridPaging(optionLiteral: 'option', optionName: "persist", optionValue: boolean): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "inherit"): boolean;
	igTreeGridPaging(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageIndexChanging"): PageIndexChangingEvent;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageIndexChanging", optionValue: PageIndexChangingEvent): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageIndexChanged"): PageIndexChangedEvent;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageIndexChanged", optionValue: PageIndexChangedEvent): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeChanging"): PageSizeChangingEvent;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeChanging", optionValue: PageSizeChangingEvent): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeChanged"): PageSizeChangedEvent;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pageSizeChanged", optionValue: PageSizeChangedEvent): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pagerRendering"): PagerRenderingEvent;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pagerRendering", optionValue: PagerRenderingEvent): void;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pagerRendered"): PagerRenderedEvent;
	igTreeGridPaging(optionLiteral: 'option', optionName: "pagerRendered", optionValue: PagerRenderedEvent): void;
	igTreeGridPaging(options: IgTreeGridPaging): JQuery;
	igTreeGridPaging(optionLiteral: 'option', optionName: string): any;
	igTreeGridPaging(optionLiteral: 'option', options: IgTreeGridPaging): JQuery;
	igTreeGridPaging(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTreeGridPaging(methodName: string, ...methodParams: any[]): any;
}
interface IgTreeGridSelection {
	multipleSelection?: boolean;
	mouseDragSelect?: boolean;
	mode?: any;
	activation?: boolean;
	wrapAround?: boolean;
	skipChildren?: boolean;
	multipleCellSelectOnClick?: boolean;
	touchDragSelect?: boolean;
	persist?: boolean;
	allowMultipleRangeSelection?: boolean;
	rowSelectionChanging?: RowSelectionChangingEvent;
	rowSelectionChanged?: RowSelectionChangedEvent;
	cellSelectionChanging?: CellSelectionChangingEvent;
	cellSelectionChanged?: CellSelectionChangedEvent;
	activeCellChanging?: ActiveCellChangingEvent;
	activeCellChanged?: ActiveCellChangedEvent;
	activeRowChanging?: ActiveRowChangingEvent;
	activeRowChanged?: ActiveRowChangedEvent;
}
interface IgTreeGridSelectionMethods {
	destroy(): void;
	clearSelection(): void;
	selectCell(row: number, col: number, isFixed: Object): void;
	selectCellById(id: Object, colKey: string): void;
	deselectCell(row: number, col: number, isFixed: Object): void;
	deselectCellById(id: Object, colKey: string): void;
	selectRow(index: number): void;
	selectRowById(id: Object): void;
	deselectRow(index: number): void;
	deselectRowById(id: Object): void;
	selectedCells(): any[];
	selectedRows(): any[];
	selectedCell(): Object;
	selectedRow(): Object;
	activeCell(): Object;
	activeRow(): Object;
}
interface JQuery {
	data(propertyName: "igTreeGridSelection"):IgTreeGridSelectionMethods;
}

interface JQuery {
	igTreeGridSelection(methodName: "destroy"): void;
	igTreeGridSelection(methodName: "clearSelection"): void;
	igTreeGridSelection(methodName: "selectCell", row: number, col: number, isFixed: Object): void;
	igTreeGridSelection(methodName: "selectCellById", id: Object, colKey: string): void;
	igTreeGridSelection(methodName: "deselectCell", row: number, col: number, isFixed: Object): void;
	igTreeGridSelection(methodName: "deselectCellById", id: Object, colKey: string): void;
	igTreeGridSelection(methodName: "selectRow", index: number): void;
	igTreeGridSelection(methodName: "selectRowById", id: Object): void;
	igTreeGridSelection(methodName: "deselectRow", index: number): void;
	igTreeGridSelection(methodName: "deselectRowById", id: Object): void;
	igTreeGridSelection(methodName: "selectedCells"): any[];
	igTreeGridSelection(methodName: "selectedRows"): any[];
	igTreeGridSelection(methodName: "selectedCell"): Object;
	igTreeGridSelection(methodName: "selectedRow"): Object;
	igTreeGridSelection(methodName: "activeCell"): Object;
	igTreeGridSelection(methodName: "activeRow"): Object;
	igTreeGridSelection(optionLiteral: 'option', optionName: "multipleSelection"): boolean;
	igTreeGridSelection(optionLiteral: 'option', optionName: "multipleSelection", optionValue: boolean): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "mouseDragSelect"): boolean;
	igTreeGridSelection(optionLiteral: 'option', optionName: "mouseDragSelect", optionValue: boolean): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "mode"): any;
	igTreeGridSelection(optionLiteral: 'option', optionName: "mode", optionValue: any): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "activation"): boolean;
	igTreeGridSelection(optionLiteral: 'option', optionName: "activation", optionValue: boolean): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "wrapAround"): boolean;
	igTreeGridSelection(optionLiteral: 'option', optionName: "wrapAround", optionValue: boolean): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "skipChildren"): boolean;
	igTreeGridSelection(optionLiteral: 'option', optionName: "skipChildren", optionValue: boolean): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "multipleCellSelectOnClick"): boolean;
	igTreeGridSelection(optionLiteral: 'option', optionName: "multipleCellSelectOnClick", optionValue: boolean): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "touchDragSelect"): boolean;
	igTreeGridSelection(optionLiteral: 'option', optionName: "touchDragSelect", optionValue: boolean): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "persist"): boolean;
	igTreeGridSelection(optionLiteral: 'option', optionName: "persist", optionValue: boolean): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "allowMultipleRangeSelection"): boolean;
	igTreeGridSelection(optionLiteral: 'option', optionName: "allowMultipleRangeSelection", optionValue: boolean): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "rowSelectionChanging"): RowSelectionChangingEvent;
	igTreeGridSelection(optionLiteral: 'option', optionName: "rowSelectionChanging", optionValue: RowSelectionChangingEvent): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "rowSelectionChanged"): RowSelectionChangedEvent;
	igTreeGridSelection(optionLiteral: 'option', optionName: "rowSelectionChanged", optionValue: RowSelectionChangedEvent): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "cellSelectionChanging"): CellSelectionChangingEvent;
	igTreeGridSelection(optionLiteral: 'option', optionName: "cellSelectionChanging", optionValue: CellSelectionChangingEvent): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "cellSelectionChanged"): CellSelectionChangedEvent;
	igTreeGridSelection(optionLiteral: 'option', optionName: "cellSelectionChanged", optionValue: CellSelectionChangedEvent): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "activeCellChanging"): ActiveCellChangingEvent;
	igTreeGridSelection(optionLiteral: 'option', optionName: "activeCellChanging", optionValue: ActiveCellChangingEvent): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "activeCellChanged"): ActiveCellChangedEvent;
	igTreeGridSelection(optionLiteral: 'option', optionName: "activeCellChanged", optionValue: ActiveCellChangedEvent): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "activeRowChanging"): ActiveRowChangingEvent;
	igTreeGridSelection(optionLiteral: 'option', optionName: "activeRowChanging", optionValue: ActiveRowChangingEvent): void;
	igTreeGridSelection(optionLiteral: 'option', optionName: "activeRowChanged"): ActiveRowChangedEvent;
	igTreeGridSelection(optionLiteral: 'option', optionName: "activeRowChanged", optionValue: ActiveRowChangedEvent): void;
	igTreeGridSelection(options: IgTreeGridSelection): JQuery;
	igTreeGridSelection(optionLiteral: 'option', optionName: string): any;
	igTreeGridSelection(optionLiteral: 'option', options: IgTreeGridSelection): JQuery;
	igTreeGridSelection(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTreeGridSelection(methodName: string, ...methodParams: any[]): any;
}
interface IgTreeGridSorting {
	fromLevel?: number;
	toLevel?: number;
	type?: any;
	caseSensitive?: boolean;
	applySortedColumnCss?: boolean;
	sortUrlKey?: string;
	sortUrlKeyAscValue?: string;
	sortUrlKeyDescValue?: string;
	mode?: any;
	customSortFunction?: Function;
	firstSortDirection?: any;
	sortedColumnTooltip?: string;
	modalDialogSortOnClick?: boolean;
	modalDialogSortByButtonText?: string;
	modalDialogResetButtonLabel?: string;
	modalDialogCaptionButtonDesc?: string;
	modalDialogCaptionButtonAsc?: string;
	modalDialogCaptionButtonUnsort?: string;
	modalDialogWidth?: number;
	modalDialogHeight?: any;
	modalDialogAnimationDuration?: number;
	featureChooserText?: string;
	unsortedColumnTooltip?: string;
	columnSettings?: IgGridSortingColumnSetting[];
	modalDialogCaptionText?: string;
	modalDialogButtonApplyText?: string;
	modalDialogButtonCancelText?: string;
	featureChooserSortAsc?: any;
	featureChooserSortDesc?: any;
	persist?: boolean;
	sortingDialogContainment?: string;
	inherit?: boolean;
	columnSorting?: ColumnSortingEvent;
	columnSorted?: ColumnSortedEvent;
	modalDialogOpening?: ModalDialogOpeningEvent;
	modalDialogOpened?: ModalDialogOpenedEvent;
	modalDialogMoving?: ModalDialogMovingEvent;
	modalDialogClosing?: ModalDialogClosingEvent;
	modalDialogClosed?: ModalDialogClosedEvent;
	modalDialogContentsRendering?: ModalDialogContentsRenderingEvent;
	modalDialogContentsRendered?: ModalDialogContentsRenderedEvent;
	modalDialogSortingChanged?: ModalDialogSortingChangedEvent;
	modalDialogButtonUnsortClick?: ModalDialogButtonUnsortClickEvent;
	modalDialogSortClick?: ModalDialogSortClickEvent;
	modalDialogButtonApplyClick?: ModalDialogButtonApplyClickEvent;
	modalDialogButtonResetClick?: ModalDialogButtonResetClickEvent;
}
interface IgTreeGridSortingMethods {
	isColumnSorted(columnKey: string): boolean;
	destroy(): void;
	sortColumn(index: Object, direction: Object, header: Object): void;
	sortMultiple(): void;
	clearSorting(): void;
	unsortColumn(index: Object, header: Object): void;
	openMultipleSortingDialog(): void;
	closeMultipleSortingDialog(): void;
	renderMultipleSortingDialogContent(isToCallEvents: Object): void;
	removeDialogClearButton(): void;
}
interface JQuery {
	data(propertyName: "igTreeGridSorting"):IgTreeGridSortingMethods;
}

interface JQuery {
	igTreeGridSorting(methodName: "isColumnSorted", columnKey: string): boolean;
	igTreeGridSorting(methodName: "destroy"): void;
	igTreeGridSorting(methodName: "sortColumn", index: Object, direction: Object, header: Object): void;
	igTreeGridSorting(methodName: "sortMultiple"): void;
	igTreeGridSorting(methodName: "clearSorting"): void;
	igTreeGridSorting(methodName: "unsortColumn", index: Object, header: Object): void;
	igTreeGridSorting(methodName: "openMultipleSortingDialog"): void;
	igTreeGridSorting(methodName: "closeMultipleSortingDialog"): void;
	igTreeGridSorting(methodName: "renderMultipleSortingDialogContent", isToCallEvents: Object): void;
	igTreeGridSorting(methodName: "removeDialogClearButton"): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "fromLevel"): number;
	igTreeGridSorting(optionLiteral: 'option', optionName: "fromLevel", optionValue: number): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "toLevel"): number;
	igTreeGridSorting(optionLiteral: 'option', optionName: "toLevel", optionValue: number): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "type"): any;
	igTreeGridSorting(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "caseSensitive"): boolean;
	igTreeGridSorting(optionLiteral: 'option', optionName: "caseSensitive", optionValue: boolean): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "applySortedColumnCss"): boolean;
	igTreeGridSorting(optionLiteral: 'option', optionName: "applySortedColumnCss", optionValue: boolean): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "sortUrlKey"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "sortUrlKey", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "sortUrlKeyAscValue"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "sortUrlKeyAscValue", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "sortUrlKeyDescValue"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "sortUrlKeyDescValue", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "mode"): any;
	igTreeGridSorting(optionLiteral: 'option', optionName: "mode", optionValue: any): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "customSortFunction"): Function;
	igTreeGridSorting(optionLiteral: 'option', optionName: "customSortFunction", optionValue: Function): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "firstSortDirection"): any;
	igTreeGridSorting(optionLiteral: 'option', optionName: "firstSortDirection", optionValue: any): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "sortedColumnTooltip"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "sortedColumnTooltip", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogSortOnClick"): boolean;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogSortOnClick", optionValue: boolean): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogSortByButtonText"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogSortByButtonText", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogResetButtonLabel"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogResetButtonLabel", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonDesc"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonDesc", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonAsc"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonAsc", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonUnsort"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionButtonUnsort", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogWidth"): number;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogWidth", optionValue: number): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogHeight"): any;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogHeight", optionValue: any): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogAnimationDuration"): number;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogAnimationDuration", optionValue: number): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "featureChooserText"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "featureChooserText", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "unsortedColumnTooltip"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "unsortedColumnTooltip", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "columnSettings"): IgGridSortingColumnSetting[];
	igTreeGridSorting(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridSortingColumnSetting[]): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionText"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogCaptionText", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonApplyText"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonApplyText", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonCancelText"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonCancelText", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "featureChooserSortAsc"): any;
	igTreeGridSorting(optionLiteral: 'option', optionName: "featureChooserSortAsc", optionValue: any): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "featureChooserSortDesc"): any;
	igTreeGridSorting(optionLiteral: 'option', optionName: "featureChooserSortDesc", optionValue: any): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "persist"): boolean;
	igTreeGridSorting(optionLiteral: 'option', optionName: "persist", optionValue: boolean): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "sortingDialogContainment"): string;
	igTreeGridSorting(optionLiteral: 'option', optionName: "sortingDialogContainment", optionValue: string): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "inherit"): boolean;
	igTreeGridSorting(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "columnSorting"): ColumnSortingEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "columnSorting", optionValue: ColumnSortingEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "columnSorted"): ColumnSortedEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "columnSorted", optionValue: ColumnSortedEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogOpening"): ModalDialogOpeningEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogOpening", optionValue: ModalDialogOpeningEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogOpened"): ModalDialogOpenedEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogOpened", optionValue: ModalDialogOpenedEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogMoving"): ModalDialogMovingEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogMoving", optionValue: ModalDialogMovingEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogClosing"): ModalDialogClosingEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogClosing", optionValue: ModalDialogClosingEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogClosed"): ModalDialogClosedEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogClosed", optionValue: ModalDialogClosedEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogContentsRendering"): ModalDialogContentsRenderingEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogContentsRendering", optionValue: ModalDialogContentsRenderingEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogContentsRendered"): ModalDialogContentsRenderedEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogContentsRendered", optionValue: ModalDialogContentsRenderedEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogSortingChanged"): ModalDialogSortingChangedEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogSortingChanged", optionValue: ModalDialogSortingChangedEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonUnsortClick"): ModalDialogButtonUnsortClickEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonUnsortClick", optionValue: ModalDialogButtonUnsortClickEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogSortClick"): ModalDialogSortClickEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogSortClick", optionValue: ModalDialogSortClickEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonApplyClick"): ModalDialogButtonApplyClickEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonApplyClick", optionValue: ModalDialogButtonApplyClickEvent): void;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonResetClick"): ModalDialogButtonResetClickEvent;
	igTreeGridSorting(optionLiteral: 'option', optionName: "modalDialogButtonResetClick", optionValue: ModalDialogButtonResetClickEvent): void;
	igTreeGridSorting(options: IgTreeGridSorting): JQuery;
	igTreeGridSorting(optionLiteral: 'option', optionName: string): any;
	igTreeGridSorting(optionLiteral: 'option', options: IgTreeGridSorting): JQuery;
	igTreeGridSorting(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTreeGridSorting(methodName: string, ...methodParams: any[]): any;
}
interface IgTreeGridTooltips {
	visibility?: any;
	style?: any;
	showDelay?: number;
	hideDelay?: number;
	columnSettings?: IgGridTooltipsColumnSettings;
	fadeTimespan?: number;
	cursorLeftOffset?: number;
	cursorTopOffset?: number;
	inherit?: boolean;
	tooltipShowing?: TooltipShowingEvent;
	tooltipShown?: TooltipShownEvent;
	tooltipHiding?: TooltipHidingEvent;
	tooltipHidden?: TooltipHiddenEvent;
}
interface IgTreeGridTooltipsMethods {
	destroy(): void;
	id(): string;
}
interface JQuery {
	data(propertyName: "igTreeGridTooltips"):IgTreeGridTooltipsMethods;
}

interface JQuery {
	igTreeGridTooltips(methodName: "destroy"): void;
	igTreeGridTooltips(methodName: "id"): string;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "visibility"): any;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "visibility", optionValue: any): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "style"): any;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "style", optionValue: any): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "showDelay"): number;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "showDelay", optionValue: number): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "hideDelay"): number;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "hideDelay", optionValue: number): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "columnSettings"): IgGridTooltipsColumnSettings;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridTooltipsColumnSettings): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "fadeTimespan"): number;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "fadeTimespan", optionValue: number): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "cursorLeftOffset"): number;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "cursorLeftOffset", optionValue: number): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "cursorTopOffset"): number;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "cursorTopOffset", optionValue: number): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "inherit"): boolean;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "tooltipShowing"): TooltipShowingEvent;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "tooltipShowing", optionValue: TooltipShowingEvent): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "tooltipShown"): TooltipShownEvent;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "tooltipShown", optionValue: TooltipShownEvent): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "tooltipHiding"): TooltipHidingEvent;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "tooltipHiding", optionValue: TooltipHidingEvent): void;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "tooltipHidden"): TooltipHiddenEvent;
	igTreeGridTooltips(optionLiteral: 'option', optionName: "tooltipHidden", optionValue: TooltipHiddenEvent): void;
	igTreeGridTooltips(options: IgTreeGridTooltips): JQuery;
	igTreeGridTooltips(optionLiteral: 'option', optionName: string): any;
	igTreeGridTooltips(optionLiteral: 'option', options: IgTreeGridTooltips): JQuery;
	igTreeGridTooltips(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTreeGridTooltips(methodName: string, ...methodParams: any[]): any;
}
interface IgTreeGridUpdating {
	enableAddRow?: boolean;
	columnSettings?: IgGridUpdatingColumnSetting[];
	editMode?: any;
	showReadonlyEditors?: boolean;
	enableDeleteRow?: boolean;
	enableAddRow?: boolean;
	validation?: boolean;
	doneLabel?: string;
	doneTooltip?: string;
	cancelLabel?: string;
	cancelTooltip?: string;
	addRowLabel?: string;
	addRowTooltip?: string;
	deleteRowLabel?: string;
	deleteRowTooltip?: string;
	rowEditDialogCaptionLabel?: string;
	showDoneCancelButtons?: boolean;
	enableDataDirtyException?: boolean;
	rowEditDialogContentHeight?: any;
	rowEditDialogFieldWidth?: number;
	rowEditDialogWidth?: any;
	rowEditDialogHeight?: any;
	startEditTriggers?: string;
	rowEditDialogContainment?: string;
	rowEditDialogOkCancelButtonWidth?: any;
	rowEditDialogRowTemplate?: string;
	rowEditDialogRowTemplateID?: string;
	horizontalMoveOnEnter?: boolean;
	excelNavigationMode?: boolean;
	saveChangesSuccessHandler?: any;
	saveChangesErrorHandler?: any;
	swipeDistance?: any;
	inherit?: boolean;
	editRowStarting?: EditRowStartingEvent;
	editRowStarted?: EditRowStartedEvent;
	editRowEnding?: EditRowEndingEvent;
	editRowEnded?: EditRowEndedEvent;
	editCellStarting?: EditCellStartingEvent;
	editCellStarted?: EditCellStartedEvent;
	editCellEnding?: EditCellEndingEvent;
	editCellEnded?: EditCellEndedEvent;
	rowAdding?: RowAddingEvent;
	rowAdded?: RowAddedEvent;
	rowDeleting?: RowDeletingEvent;
	rowDeleted?: RowDeletedEvent;
	dataDirty?: DataDirtyEvent;
	generatePrimaryKeyValue?: GeneratePrimaryKeyValueEvent;
	rowEditDialogOpening?: RowEditDialogOpeningEvent;
	rowEditDialogOpened?: RowEditDialogOpenedEvent;
	rowEditDialogContentsRendering?: RowEditDialogContentsRenderingEvent;
	rowEditDialogContentsRendered?: RowEditDialogContentsRenderedEvent;
	rowEditDialogClosing?: RowEditDialogClosingEvent;
	rowEditDialogClosed?: RowEditDialogClosedEvent;
}
interface IgTreeGridUpdatingMethods {
	destroy(): void;
	setCellValue(rowId: Object, colKey: string, value: Object, tr?: Element): void;
	updateRow(rowId: Object, values: Object, tr?: Element): void;
	addRow(values: Object): void;
	deleteRow(rowId: Object, tr?: Element): void;
	startEdit(row: Object, col: Object, e?: boolean): boolean;
	startAddRowEdit(e?: boolean): boolean;
	endEdit(update?: boolean, e?: boolean): boolean;
	findInvalid(): void;
	isEditing(): boolean;
	editorForKey(key: Object): Object;
	editorForCell(td: string, add?: boolean): Object;
	findHiddenComboEditor(editor: string): Object;
}
interface JQuery {
	data(propertyName: "igTreeGridUpdating"):IgTreeGridUpdatingMethods;
}

interface JQuery {
	igTreeGridUpdating(methodName: "destroy"): void;
	igTreeGridUpdating(methodName: "setCellValue", rowId: Object, colKey: string, value: Object, tr?: Element): void;
	igTreeGridUpdating(methodName: "updateRow", rowId: Object, values: Object, tr?: Element): void;
	igTreeGridUpdating(methodName: "addRow", values: Object): void;
	igTreeGridUpdating(methodName: "deleteRow", rowId: Object, tr?: Element): void;
	igTreeGridUpdating(methodName: "startEdit", row: Object, col: Object, e?: boolean): boolean;
	igTreeGridUpdating(methodName: "startAddRowEdit", e?: boolean): boolean;
	igTreeGridUpdating(methodName: "endEdit", update?: boolean, e?: boolean): boolean;
	igTreeGridUpdating(methodName: "findInvalid"): void;
	igTreeGridUpdating(methodName: "isEditing"): boolean;
	igTreeGridUpdating(methodName: "editorForKey", key: Object): Object;
	igTreeGridUpdating(methodName: "editorForCell", td: string, add?: boolean): Object;
	igTreeGridUpdating(methodName: "findHiddenComboEditor", editor: string): Object;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "enableAddRow"): boolean;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "enableAddRow", optionValue: boolean): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "columnSettings"): IgGridUpdatingColumnSetting[];
	igTreeGridUpdating(optionLiteral: 'option', optionName: "columnSettings", optionValue: IgGridUpdatingColumnSetting[]): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editMode"): any;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editMode", optionValue: any): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "showReadonlyEditors"): boolean;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "showReadonlyEditors", optionValue: boolean): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "enableDeleteRow"): boolean;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "enableDeleteRow", optionValue: boolean): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "enableAddRow"): boolean;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "enableAddRow", optionValue: boolean): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "validation"): boolean;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "validation", optionValue: boolean): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "doneLabel"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "doneLabel", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "doneTooltip"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "doneTooltip", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "cancelLabel"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "cancelLabel", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "cancelTooltip"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "cancelTooltip", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "addRowLabel"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "addRowLabel", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "addRowTooltip"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "addRowTooltip", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "deleteRowLabel"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "deleteRowLabel", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "deleteRowTooltip"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "deleteRowTooltip", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogCaptionLabel"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogCaptionLabel", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "showDoneCancelButtons"): boolean;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "showDoneCancelButtons", optionValue: boolean): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "enableDataDirtyException"): boolean;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "enableDataDirtyException", optionValue: boolean): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentHeight"): any;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentHeight", optionValue: any): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogFieldWidth"): number;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogFieldWidth", optionValue: number): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogWidth"): any;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogWidth", optionValue: any): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogHeight"): any;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogHeight", optionValue: any): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "startEditTriggers"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "startEditTriggers", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContainment"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContainment", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOkCancelButtonWidth"): any;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOkCancelButtonWidth", optionValue: any): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogRowTemplate"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogRowTemplate", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogRowTemplateID"): string;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogRowTemplateID", optionValue: string): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "horizontalMoveOnEnter"): boolean;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "horizontalMoveOnEnter", optionValue: boolean): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "excelNavigationMode"): boolean;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "excelNavigationMode", optionValue: boolean): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "saveChangesSuccessHandler"): any;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "saveChangesSuccessHandler", optionValue: any): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "saveChangesErrorHandler"): any;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "saveChangesErrorHandler", optionValue: any): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "swipeDistance"): any;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "swipeDistance", optionValue: any): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "inherit"): boolean;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "inherit", optionValue: boolean): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editRowStarting"): EditRowStartingEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editRowStarting", optionValue: EditRowStartingEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editRowStarted"): EditRowStartedEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editRowStarted", optionValue: EditRowStartedEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editRowEnding"): EditRowEndingEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editRowEnding", optionValue: EditRowEndingEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editRowEnded"): EditRowEndedEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editRowEnded", optionValue: EditRowEndedEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editCellStarting"): EditCellStartingEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editCellStarting", optionValue: EditCellStartingEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editCellStarted"): EditCellStartedEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editCellStarted", optionValue: EditCellStartedEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editCellEnding"): EditCellEndingEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editCellEnding", optionValue: EditCellEndingEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editCellEnded"): EditCellEndedEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "editCellEnded", optionValue: EditCellEndedEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowAdding"): RowAddingEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowAdding", optionValue: RowAddingEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowAdded"): RowAddedEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowAdded", optionValue: RowAddedEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowDeleting"): RowDeletingEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowDeleting", optionValue: RowDeletingEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowDeleted"): RowDeletedEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowDeleted", optionValue: RowDeletedEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "dataDirty"): DataDirtyEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "dataDirty", optionValue: DataDirtyEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "generatePrimaryKeyValue"): GeneratePrimaryKeyValueEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "generatePrimaryKeyValue", optionValue: GeneratePrimaryKeyValueEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOpening"): RowEditDialogOpeningEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOpening", optionValue: RowEditDialogOpeningEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOpened"): RowEditDialogOpenedEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogOpened", optionValue: RowEditDialogOpenedEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentsRendering"): RowEditDialogContentsRenderingEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentsRendering", optionValue: RowEditDialogContentsRenderingEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentsRendered"): RowEditDialogContentsRenderedEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogContentsRendered", optionValue: RowEditDialogContentsRenderedEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogClosing"): RowEditDialogClosingEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogClosing", optionValue: RowEditDialogClosingEvent): void;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogClosed"): RowEditDialogClosedEvent;
	igTreeGridUpdating(optionLiteral: 'option', optionName: "rowEditDialogClosed", optionValue: RowEditDialogClosedEvent): void;
	igTreeGridUpdating(options: IgTreeGridUpdating): JQuery;
	igTreeGridUpdating(optionLiteral: 'option', optionName: string): any;
	igTreeGridUpdating(optionLiteral: 'option', options: IgTreeGridUpdating): JQuery;
	igTreeGridUpdating(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igTreeGridUpdating(methodName: string, ...methodParams: any[]): any;
}
interface IgBrowseButton {
	autoselect?: boolean;
	multipleFiles?: boolean;
	container?: any;
}
interface IgBrowseButtonMethods {
	attachFilePicker(e: Object, isHidden: Object): void;
	getFilePicker(): void;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igBrowseButton"):IgBrowseButtonMethods;
}

interface IgUploadFileExtensionIcons {
	ext?: string;
	css?: string;
	def?: boolean;
}

interface FileSelectingEvent {
	(event: Event, ui: FileSelectingEventUIParam): void;
}

interface FileSelectingEventUIParam {
	owner?: any;
}

interface FileSelectedEvent {
	(event: Event, ui: FileSelectedEventUIParam): void;
}

interface FileSelectedEventUIParam {
	fileId?: any;
	filePath?: any;
	owner?: any;
}

interface FileUploadingEvent {
	(event: Event, ui: FileUploadingEventUIParam): void;
}

interface FileUploadingEventUIParam {
	fileId?: any;
	filePath?: any;
	totalSize?: any;
	uploadedBytes?: any;
	fileStatus?: any;
	fileInfo?: any;
	owner?: any;
}

interface FileUploadedEvent {
	(event: Event, ui: FileUploadedEventUIParam): void;
}

interface FileUploadedEventUIParam {
	fileId?: any;
	filePath?: any;
	totalSize?: any;
	fileInfo?: any;
	owner?: any;
}

interface FileUploadAbortedEvent {
	(event: Event, ui: FileUploadAbortedEventUIParam): void;
}

interface FileUploadAbortedEventUIParam {
	fileId?: any;
	filePath?: any;
	totalSize?: any;
	uploadedBytes?: any;
	fileStatus?: any;
	owner?: any;
}

interface CancelAllClickedEvent {
	(event: Event, ui: CancelAllClickedEventUIParam): void;
}

interface CancelAllClickedEventUIParam {
	owner?: any;
}

interface OnErrorEvent {
	(event: Event, ui: OnErrorEventUIParam): void;
}

interface OnErrorEventUIParam {
	errorCode?: any;
	fileId?: any;
	errorMessage?: any;
	errorType?: any;
	serverMessage?: any;
	owner?: any;
}

interface FileExtensionsValidatingEvent {
	(event: Event, ui: FileExtensionsValidatingEventUIParam): void;
}

interface FileExtensionsValidatingEventUIParam {
	fileName?: any;
	fileExtension?: any;
	owner?: any;
}

interface OnXHRLoadEvent {
	(event: Event, ui: OnXHRLoadEventUIParam): void;
}

interface OnXHRLoadEventUIParam {
	fileId?: any;
	xhr?: any;
	fileInfo?: any;
	owner?: any;
}

interface OnFormDataSubmitEvent {
	(event: Event, ui: OnFormDataSubmitEventUIParam): void;
}

interface OnFormDataSubmitEventUIParam {
	fileId?: any;
	fileInfo?: any;
	xhr?: any;
	formData?: any;
	owner?: any;
}

interface IgUpload {
	width?: number;
	height?: number;
	autostartupload?: boolean;
	labelUploadButton?: string;
	labelAddButton?: string;
	labelClearAllButton?: string;
	labelSummaryTemplate?: string;
	labelSummaryProgressBarTemplate?: string;
	labelShowDetails?: string;
	labelHideDetails?: string;
	labelSummaryProgressButtonCancel?: string;
	labelSummaryProgressButtonContinue?: string;
	labelSummaryProgressButtonDone?: string;
	labelProgressBarFileNameContinue?: string;
	errorMessageMaxFileSizeExceeded?: string;
	errorMessageGetFileStatus?: string;
	errorMessageCancelUpload?: string;
	errorMessageNoSuchFile?: string;
	errorMessageOther?: string;
	errorMessageValidatingFileExtension?: string;
	errorMessageAJAXRequestFileSize?: string;
	errorMessageTryToRemoveNonExistingFile?: string;
	errorMessageTryToStartNonExistingFile?: string;
	errorMessageMaxUploadedFiles?: string;
	errorMessageMaxSimultaneousFiles?: string;
	errorMessageDropMultipleFilesWhenSingleModel?: string;
	uploadUrl?: string;
	progressUrl?: string;
	allowedExtensions?: string;
	showFileExtensionIcon?: boolean;
	css?: any;
	fileExtensionIcons?: IgUploadFileExtensionIcons;
	mode?: any;
	multipleFiles?: boolean;
	maxUploadedFiles?: number;
	maxSimultaneousFilesUploads?: number;
	fileSizeMetric?: any;
	controlId?: string;
	fileSizeDecimalDisplay?: number;
	maxFileSize?: any;
	fileSelecting?: FileSelectingEvent;
	fileSelected?: FileSelectedEvent;
	fileUploading?: FileUploadingEvent;
	fileUploaded?: FileUploadedEvent;
	fileUploadAborted?: FileUploadAbortedEvent;
	cancelAllClicked?: CancelAllClickedEvent;
	onError?: OnErrorEvent;
	fileExtensionsValidating?: FileExtensionsValidatingEvent;
	onXHRLoad?: OnXHRLoadEvent;
	onFormDataSubmit?: OnFormDataSubmitEvent;
}
interface IgUploadMethods {
	container(): void;
	widget(): void;
	clearAll(): void;
	addDataField(formData: Object, field: Object): void;
	addDataFields(formData: Object, fields: any[]): void;
	startUpload(formNumber: number): void;
	cancelUpload(formNumber: number): void;
	destroy(): void;
	getFileInfoData(): Object;
	cancelAll(): void;
	getFileInfo(fileIndex: number): Object;
}
interface JQuery {
	data(propertyName: "igUpload"):IgUploadMethods;
}

interface JQuery {
	igBrowseButton(methodName: "attachFilePicker", e: Object, isHidden: Object): void;
	igBrowseButton(methodName: "getFilePicker"): void;
	igBrowseButton(methodName: "destroy"): void;
	igBrowseButton(optionLiteral: 'option', optionName: "autoselect"): boolean;
	igBrowseButton(optionLiteral: 'option', optionName: "autoselect", optionValue: boolean): void;
	igBrowseButton(optionLiteral: 'option', optionName: "multipleFiles"): boolean;
	igBrowseButton(optionLiteral: 'option', optionName: "multipleFiles", optionValue: boolean): void;
	igBrowseButton(optionLiteral: 'option', optionName: "container"): any;
	igBrowseButton(optionLiteral: 'option', optionName: "container", optionValue: any): void;
	igBrowseButton(options: IgBrowseButton): JQuery;
	igBrowseButton(optionLiteral: 'option', optionName: string): any;
	igBrowseButton(optionLiteral: 'option', options: IgBrowseButton): JQuery;
	igBrowseButton(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igBrowseButton(methodName: string, ...methodParams: any[]): any;
}
interface JQuery {
	igUpload(methodName: "container"): void;
	igUpload(methodName: "widget"): void;
	igUpload(methodName: "clearAll"): void;
	igUpload(methodName: "addDataField", formData: Object, field: Object): void;
	igUpload(methodName: "addDataFields", formData: Object, fields: any[]): void;
	igUpload(methodName: "startUpload", formNumber: number): void;
	igUpload(methodName: "cancelUpload", formNumber: number): void;
	igUpload(methodName: "destroy"): void;
	igUpload(methodName: "getFileInfoData"): Object;
	igUpload(methodName: "cancelAll"): void;
	igUpload(methodName: "getFileInfo", fileIndex: number): Object;
	igUpload(optionLiteral: 'option', optionName: "width"): number;
	igUpload(optionLiteral: 'option', optionName: "width", optionValue: number): void;
	igUpload(optionLiteral: 'option', optionName: "height"): number;
	igUpload(optionLiteral: 'option', optionName: "height", optionValue: number): void;
	igUpload(optionLiteral: 'option', optionName: "autostartupload"): boolean;
	igUpload(optionLiteral: 'option', optionName: "autostartupload", optionValue: boolean): void;
	igUpload(optionLiteral: 'option', optionName: "labelUploadButton"): string;
	igUpload(optionLiteral: 'option', optionName: "labelUploadButton", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "labelAddButton"): string;
	igUpload(optionLiteral: 'option', optionName: "labelAddButton", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "labelClearAllButton"): string;
	igUpload(optionLiteral: 'option', optionName: "labelClearAllButton", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "labelSummaryTemplate"): string;
	igUpload(optionLiteral: 'option', optionName: "labelSummaryTemplate", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "labelSummaryProgressBarTemplate"): string;
	igUpload(optionLiteral: 'option', optionName: "labelSummaryProgressBarTemplate", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "labelShowDetails"): string;
	igUpload(optionLiteral: 'option', optionName: "labelShowDetails", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "labelHideDetails"): string;
	igUpload(optionLiteral: 'option', optionName: "labelHideDetails", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "labelSummaryProgressButtonCancel"): string;
	igUpload(optionLiteral: 'option', optionName: "labelSummaryProgressButtonCancel", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "labelSummaryProgressButtonContinue"): string;
	igUpload(optionLiteral: 'option', optionName: "labelSummaryProgressButtonContinue", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "labelSummaryProgressButtonDone"): string;
	igUpload(optionLiteral: 'option', optionName: "labelSummaryProgressButtonDone", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "labelProgressBarFileNameContinue"): string;
	igUpload(optionLiteral: 'option', optionName: "labelProgressBarFileNameContinue", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageMaxFileSizeExceeded"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageMaxFileSizeExceeded", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageGetFileStatus"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageGetFileStatus", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageCancelUpload"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageCancelUpload", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageNoSuchFile"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageNoSuchFile", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageOther"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageOther", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageValidatingFileExtension"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageValidatingFileExtension", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageAJAXRequestFileSize"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageAJAXRequestFileSize", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageTryToRemoveNonExistingFile"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageTryToRemoveNonExistingFile", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageTryToStartNonExistingFile"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageTryToStartNonExistingFile", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageMaxUploadedFiles"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageMaxUploadedFiles", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageMaxSimultaneousFiles"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageMaxSimultaneousFiles", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "errorMessageDropMultipleFilesWhenSingleModel"): string;
	igUpload(optionLiteral: 'option', optionName: "errorMessageDropMultipleFilesWhenSingleModel", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "uploadUrl"): string;
	igUpload(optionLiteral: 'option', optionName: "uploadUrl", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "progressUrl"): string;
	igUpload(optionLiteral: 'option', optionName: "progressUrl", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "allowedExtensions"): string;
	igUpload(optionLiteral: 'option', optionName: "allowedExtensions", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "showFileExtensionIcon"): boolean;
	igUpload(optionLiteral: 'option', optionName: "showFileExtensionIcon", optionValue: boolean): void;
	igUpload(optionLiteral: 'option', optionName: "css"): any;
	igUpload(optionLiteral: 'option', optionName: "css", optionValue: any): void;
	igUpload(optionLiteral: 'option', optionName: "fileExtensionIcons"): IgUploadFileExtensionIcons;
	igUpload(optionLiteral: 'option', optionName: "fileExtensionIcons", optionValue: IgUploadFileExtensionIcons): void;
	igUpload(optionLiteral: 'option', optionName: "mode"): any;
	igUpload(optionLiteral: 'option', optionName: "mode", optionValue: any): void;
	igUpload(optionLiteral: 'option', optionName: "multipleFiles"): boolean;
	igUpload(optionLiteral: 'option', optionName: "multipleFiles", optionValue: boolean): void;
	igUpload(optionLiteral: 'option', optionName: "maxUploadedFiles"): number;
	igUpload(optionLiteral: 'option', optionName: "maxUploadedFiles", optionValue: number): void;
	igUpload(optionLiteral: 'option', optionName: "maxSimultaneousFilesUploads"): number;
	igUpload(optionLiteral: 'option', optionName: "maxSimultaneousFilesUploads", optionValue: number): void;
	igUpload(optionLiteral: 'option', optionName: "fileSizeMetric"): any;
	igUpload(optionLiteral: 'option', optionName: "fileSizeMetric", optionValue: any): void;
	igUpload(optionLiteral: 'option', optionName: "controlId"): string;
	igUpload(optionLiteral: 'option', optionName: "controlId", optionValue: string): void;
	igUpload(optionLiteral: 'option', optionName: "fileSizeDecimalDisplay"): number;
	igUpload(optionLiteral: 'option', optionName: "fileSizeDecimalDisplay", optionValue: number): void;
	igUpload(optionLiteral: 'option', optionName: "maxFileSize"): any;
	igUpload(optionLiteral: 'option', optionName: "maxFileSize", optionValue: any): void;
	igUpload(optionLiteral: 'option', optionName: "fileSelecting"): FileSelectingEvent;
	igUpload(optionLiteral: 'option', optionName: "fileSelecting", optionValue: FileSelectingEvent): void;
	igUpload(optionLiteral: 'option', optionName: "fileSelected"): FileSelectedEvent;
	igUpload(optionLiteral: 'option', optionName: "fileSelected", optionValue: FileSelectedEvent): void;
	igUpload(optionLiteral: 'option', optionName: "fileUploading"): FileUploadingEvent;
	igUpload(optionLiteral: 'option', optionName: "fileUploading", optionValue: FileUploadingEvent): void;
	igUpload(optionLiteral: 'option', optionName: "fileUploaded"): FileUploadedEvent;
	igUpload(optionLiteral: 'option', optionName: "fileUploaded", optionValue: FileUploadedEvent): void;
	igUpload(optionLiteral: 'option', optionName: "fileUploadAborted"): FileUploadAbortedEvent;
	igUpload(optionLiteral: 'option', optionName: "fileUploadAborted", optionValue: FileUploadAbortedEvent): void;
	igUpload(optionLiteral: 'option', optionName: "cancelAllClicked"): CancelAllClickedEvent;
	igUpload(optionLiteral: 'option', optionName: "cancelAllClicked", optionValue: CancelAllClickedEvent): void;
	igUpload(optionLiteral: 'option', optionName: "onError"): OnErrorEvent;
	igUpload(optionLiteral: 'option', optionName: "onError", optionValue: OnErrorEvent): void;
	igUpload(optionLiteral: 'option', optionName: "fileExtensionsValidating"): FileExtensionsValidatingEvent;
	igUpload(optionLiteral: 'option', optionName: "fileExtensionsValidating", optionValue: FileExtensionsValidatingEvent): void;
	igUpload(optionLiteral: 'option', optionName: "onXHRLoad"): OnXHRLoadEvent;
	igUpload(optionLiteral: 'option', optionName: "onXHRLoad", optionValue: OnXHRLoadEvent): void;
	igUpload(optionLiteral: 'option', optionName: "onFormDataSubmit"): OnFormDataSubmitEvent;
	igUpload(optionLiteral: 'option', optionName: "onFormDataSubmit", optionValue: OnFormDataSubmitEvent): void;
	igUpload(options: IgUpload): JQuery;
	igUpload(optionLiteral: 'option', optionName: string): any;
	igUpload(optionLiteral: 'option', options: IgUpload): JQuery;
	igUpload(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igUpload(methodName: string, ...methodParams: any[]): any;
}
interface CheckValueEvent {
	(event: Event, ui: CheckValueEventUIParam): void;
}

interface CheckValueEventUIParam {
	message?: any;
	value?: any;
}

interface ValidationEvent {
	(event: Event, ui: ValidationEventUIParam): void;
}

interface ValidationEventUIParam {
	message?: any;
	invalid?: any;
}

interface ErrorShowingEvent {
	(event: Event, ui: ErrorShowingEventUIParam): void;
}

interface ErrorShowingEventUIParam {
	message?: any;
}

interface ErrorHidingEvent {
	(event: Event, ui: ErrorHidingEventUIParam): void;
}

interface ErrorHidingEventUIParam {
	message?: any;
}

interface ErrorShownEvent {
	(event: Event, ui: ErrorShownEventUIParam): void;
}

interface ErrorShownEventUIParam {
	message?: any;
}

interface ErrorHiddenEvent {
	(event: Event, ui: ErrorHiddenEventUIParam): void;
}

interface ErrorHiddenEventUIParam {
	message?: any;
}

interface IgValidator {
	showIcon?: boolean;
	animationShow?: number;
	animationHide?: number;
	enableTargetErrorCss?: boolean;
	alignment?: string;
	keepFocus?: any;
	onchange?: boolean;
	onblur?: boolean;
	formSubmit?: boolean;
	onsubmit?: boolean;
	bodyAsParent?: boolean;
	required?: boolean;
	minLength?: number;
	maxLength?: number;
	min?: number;
	max?: number;
	regExp?: any;
	checkboxesName?: boolean;
	locale?: any;
	errorLabel?: Element;
	element?: Element;
	theme?: string;
	errorMessage?: string;
	checkValue?: CheckValueEvent;
	validation?: ValidationEvent;
	errorShowing?: ErrorShowingEvent;
	errorHiding?: ErrorHidingEvent;
	errorShown?: ErrorShownEvent;
	errorHidden?: ErrorHiddenEvent;
}
interface IgValidatorMethods {
	getLocaleOption(name: string): string;
	isMessageDisplayed(): boolean;
	isValidState(): boolean;
	hide(keepCss?: boolean): void;
	validate(e?: Object, submit?: number, check?: boolean): void;
	destroy(): Object;
}
interface JQuery {
	data(propertyName: "igValidator"):IgValidatorMethods;
}

interface JQuery {
	igValidator(methodName: "getLocaleOption", name: string): string;
	igValidator(methodName: "isMessageDisplayed"): boolean;
	igValidator(methodName: "isValidState"): boolean;
	igValidator(methodName: "hide", keepCss?: boolean): void;
	igValidator(methodName: "validate", e?: Object, submit?: number, check?: boolean): void;
	igValidator(methodName: "destroy"): Object;
	igValidator(optionLiteral: 'option', optionName: "showIcon"): boolean;
	igValidator(optionLiteral: 'option', optionName: "showIcon", optionValue: boolean): void;
	igValidator(optionLiteral: 'option', optionName: "animationShow"): number;
	igValidator(optionLiteral: 'option', optionName: "animationShow", optionValue: number): void;
	igValidator(optionLiteral: 'option', optionName: "animationHide"): number;
	igValidator(optionLiteral: 'option', optionName: "animationHide", optionValue: number): void;
	igValidator(optionLiteral: 'option', optionName: "enableTargetErrorCss"): boolean;
	igValidator(optionLiteral: 'option', optionName: "enableTargetErrorCss", optionValue: boolean): void;
	igValidator(optionLiteral: 'option', optionName: "alignment"): string;
	igValidator(optionLiteral: 'option', optionName: "alignment", optionValue: string): void;
	igValidator(optionLiteral: 'option', optionName: "keepFocus"): any;
	igValidator(optionLiteral: 'option', optionName: "keepFocus", optionValue: any): void;
	igValidator(optionLiteral: 'option', optionName: "onchange"): boolean;
	igValidator(optionLiteral: 'option', optionName: "onchange", optionValue: boolean): void;
	igValidator(optionLiteral: 'option', optionName: "onblur"): boolean;
	igValidator(optionLiteral: 'option', optionName: "onblur", optionValue: boolean): void;
	igValidator(optionLiteral: 'option', optionName: "formSubmit"): boolean;
	igValidator(optionLiteral: 'option', optionName: "formSubmit", optionValue: boolean): void;
	igValidator(optionLiteral: 'option', optionName: "onsubmit"): boolean;
	igValidator(optionLiteral: 'option', optionName: "onsubmit", optionValue: boolean): void;
	igValidator(optionLiteral: 'option', optionName: "bodyAsParent"): boolean;
	igValidator(optionLiteral: 'option', optionName: "bodyAsParent", optionValue: boolean): void;
	igValidator(optionLiteral: 'option', optionName: "required"): boolean;
	igValidator(optionLiteral: 'option', optionName: "required", optionValue: boolean): void;
	igValidator(optionLiteral: 'option', optionName: "minLength"): number;
	igValidator(optionLiteral: 'option', optionName: "minLength", optionValue: number): void;
	igValidator(optionLiteral: 'option', optionName: "maxLength"): number;
	igValidator(optionLiteral: 'option', optionName: "maxLength", optionValue: number): void;
	igValidator(optionLiteral: 'option', optionName: "min"): number;
	igValidator(optionLiteral: 'option', optionName: "min", optionValue: number): void;
	igValidator(optionLiteral: 'option', optionName: "max"): number;
	igValidator(optionLiteral: 'option', optionName: "max", optionValue: number): void;
	igValidator(optionLiteral: 'option', optionName: "regExp"): any;
	igValidator(optionLiteral: 'option', optionName: "regExp", optionValue: any): void;
	igValidator(optionLiteral: 'option', optionName: "checkboxesName"): boolean;
	igValidator(optionLiteral: 'option', optionName: "checkboxesName", optionValue: boolean): void;
	igValidator(optionLiteral: 'option', optionName: "locale"): any;
	igValidator(optionLiteral: 'option', optionName: "locale", optionValue: any): void;
	igValidator(optionLiteral: 'option', optionName: "errorLabel"): Element;
	igValidator(optionLiteral: 'option', optionName: "errorLabel", optionValue: Element): void;
	igValidator(optionLiteral: 'option', optionName: "element"): Element;
	igValidator(optionLiteral: 'option', optionName: "element", optionValue: Element): void;
	igValidator(optionLiteral: 'option', optionName: "theme"): string;
	igValidator(optionLiteral: 'option', optionName: "theme", optionValue: string): void;
	igValidator(optionLiteral: 'option', optionName: "errorMessage"): string;
	igValidator(optionLiteral: 'option', optionName: "errorMessage", optionValue: string): void;
	igValidator(optionLiteral: 'option', optionName: "checkValue"): CheckValueEvent;
	igValidator(optionLiteral: 'option', optionName: "checkValue", optionValue: CheckValueEvent): void;
	igValidator(optionLiteral: 'option', optionName: "validation"): ValidationEvent;
	igValidator(optionLiteral: 'option', optionName: "validation", optionValue: ValidationEvent): void;
	igValidator(optionLiteral: 'option', optionName: "errorShowing"): ErrorShowingEvent;
	igValidator(optionLiteral: 'option', optionName: "errorShowing", optionValue: ErrorShowingEvent): void;
	igValidator(optionLiteral: 'option', optionName: "errorHiding"): ErrorHidingEvent;
	igValidator(optionLiteral: 'option', optionName: "errorHiding", optionValue: ErrorHidingEvent): void;
	igValidator(optionLiteral: 'option', optionName: "errorShown"): ErrorShownEvent;
	igValidator(optionLiteral: 'option', optionName: "errorShown", optionValue: ErrorShownEvent): void;
	igValidator(optionLiteral: 'option', optionName: "errorHidden"): ErrorHiddenEvent;
	igValidator(optionLiteral: 'option', optionName: "errorHidden", optionValue: ErrorHiddenEvent): void;
	igValidator(options: IgValidator): JQuery;
	igValidator(optionLiteral: 'option', optionName: string): any;
	igValidator(optionLiteral: 'option', options: IgValidator): JQuery;
	igValidator(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igValidator(methodName: string, ...methodParams: any[]): any;
}
interface IgVideoPlayerBookmark {
	time?: number;
	title?: string;
	disabled?: boolean;
}

interface IgVideoPlayerRelatedVideo {
	imageUrl?: string;
	title?: string;
	width?: number;
	height?: number;
	link?: string;
	sources?: any[];
	css?: string;
}

interface IgVideoPlayerBanner {
	imageUrl?: string;
	times?: any[];
	closeBanner?: boolean;
	animate?: boolean;
	visible?: boolean;
	duration?: number;
	autohide?: boolean;
	hidedelay?: number;
	link?: string;
	width?: number;
	height?: number;
	css?: string;
}

interface IgVideoPlayerCommercialsLinkedCommercial {
	sources?: any[];
	startTime?: number;
	link?: string;
	title?: string;
}

interface IgVideoPlayerCommercialsEmbeddedCommercial {
	startTime?: number;
	endTime?: number;
	link?: string;
	title?: string;
}

interface IgVideoPlayerCommercialsAdMessage {
	animate?: boolean;
	autoHide?: boolean;
	hideDelay?: number;
	animationDuration?: number;
}

interface IgVideoPlayerCommercials {
	linkedCommercials?: IgVideoPlayerCommercialsLinkedCommercial[];
	embeddedCommercials?: IgVideoPlayerCommercialsEmbeddedCommercial[];
	alwaysPlayCommercials?: boolean;
	showBookmarks?: boolean;
	adMessage?: IgVideoPlayerCommercialsAdMessage;
}

interface EndedEvent {
	(event: Event, ui: EndedEventUIParam): void;
}

interface EndedEventUIParam {
	source?: any;
	duration?: any;
}

interface PlayingEvent {
	(event: Event, ui: PlayingEventUIParam): void;
}

interface PlayingEventUIParam {
	source?: any;
	duration?: any;
}

interface PausedEvent {
	(event: Event, ui: PausedEventUIParam): void;
}

interface PausedEventUIParam {
	source?: any;
	duration?: any;
}

interface BufferingEvent {
	(event: Event, ui: BufferingEventUIParam): void;
}

interface BufferingEventUIParam {
	source?: any;
	buffered?: any;
}

interface ProgressEvent {
	(event: Event, ui: ProgressEventUIParam): void;
}

interface ProgressEventUIParam {
	source?: any;
	currentTime?: any;
	duration?: any;
}

interface WaitingEvent {
	(event: Event, ui: WaitingEventUIParam): void;
}

interface WaitingEventUIParam {
	source?: any;
	currentTime?: any;
	duration?: any;
}

interface EnterFullScreenEvent {
	(event: Event, ui: EnterFullScreenEventUIParam): void;
}

interface EnterFullScreenEventUIParam {
	source?: any;
}

interface ExitFullScreenEvent {
	(event: Event, ui: ExitFullScreenEventUIParam): void;
}

interface ExitFullScreenEventUIParam {
	source?: any;
}

interface RelatedVideoClickEvent {
	(event: Event, ui: RelatedVideoClickEventUIParam): void;
}

interface RelatedVideoClickEventUIParam {
	relatedVideo?: any;
	relatedVideoElement?: any;
}

interface BannerVisibleEvent {
	(event: Event, ui: BannerVisibleEventUIParam): void;
}

interface BannerVisibleEventUIParam {
	index?: any;
	banner?: any;
	bannerElement?: any;
}

interface BannerHiddenEvent {
	(event: Event, ui: BannerHiddenEventUIParam): void;
}

interface BannerHiddenEventUIParam {
	index?: any;
	banner?: any;
	bannerElement?: any;
}

interface BannerClickEvent {
	(event: Event, ui: BannerClickEventUIParam): void;
}

interface BannerClickEventUIParam {
	bannerElement?: any;
}

interface IgVideoPlayer {
	sources?: any[];
	width?: number;
	height?: number;
	posterUrl?: string;
	preload?: boolean;
	autoplay?: boolean;
	autohide?: boolean;
	volumeAutohideDelay?: number;
	centerButtonHideDelay?: number;
	loop?: boolean;
	browserControls?: boolean;
	fullscreen?: boolean;
	volume?: number;
	muted?: boolean;
	title?: string;
	showSeekTime?: boolean;
	progressLabelFormat?: string;
	bookmarks?: IgVideoPlayerBookmark[];
	relatedVideos?: IgVideoPlayerRelatedVideo[];
	banners?: IgVideoPlayerBanner[];
	commercials?: IgVideoPlayerCommercials;
	ended?: EndedEvent;
	playing?: PlayingEvent;
	paused?: PausedEvent;
	buffering?: BufferingEvent;
	progress?: ProgressEvent;
	waiting?: WaitingEvent;
	bookmarkHit?: BookmarkHitEvent;
	bookmarkClick?: BookmarkClickEvent;
	enterFullScreen?: EnterFullScreenEvent;
	exitFullScreen?: ExitFullScreenEvent;
	relatedVideoClick?: RelatedVideoClickEvent;
	bannerVisible?: BannerVisibleEvent;
	bannerHidden?: BannerHiddenEvent;
	bannerClick?: BannerClickEvent;
	browserNotSupported?: BrowserNotSupportedEvent;
}
interface IgVideoPlayerMethods {
	widget(): void;
	hideAdMessage(): void;
	playCommercial(commercial: Object): void;
	showBanner(index: number): void;
	hideBanner(index: number): void;
	resetCommercialsShow(): void;
	togglePlay(): void;
	play(): void;
	pause(): void;
	currentTime(val: number): number;
	screenshot(scaleFactor?: number): Object;
	supportsVideo(): boolean;
	supportsH264BaselineVideo(): boolean;
	supportsOggTheoraVideo(): boolean;
	supportsWebmVideo(): boolean;
	paused(): boolean;
	ended(): boolean;
	duration(): number;
	seeking(): boolean;
	destroy(): void;
}
interface JQuery {
	data(propertyName: "igVideoPlayer"):IgVideoPlayerMethods;
}

interface JQuery {
	igVideoPlayer(methodName: "widget"): void;
	igVideoPlayer(methodName: "hideAdMessage"): void;
	igVideoPlayer(methodName: "playCommercial", commercial: Object): void;
	igVideoPlayer(methodName: "showBanner", index: number): void;
	igVideoPlayer(methodName: "hideBanner", index: number): void;
	igVideoPlayer(methodName: "resetCommercialsShow"): void;
	igVideoPlayer(methodName: "togglePlay"): void;
	igVideoPlayer(methodName: "play"): void;
	igVideoPlayer(methodName: "pause"): void;
	igVideoPlayer(methodName: "currentTime", val: number): number;
	igVideoPlayer(methodName: "screenshot", scaleFactor?: number): Object;
	igVideoPlayer(methodName: "supportsVideo"): boolean;
	igVideoPlayer(methodName: "supportsH264BaselineVideo"): boolean;
	igVideoPlayer(methodName: "supportsOggTheoraVideo"): boolean;
	igVideoPlayer(methodName: "supportsWebmVideo"): boolean;
	igVideoPlayer(methodName: "paused"): boolean;
	igVideoPlayer(methodName: "ended"): boolean;
	igVideoPlayer(methodName: "duration"): number;
	igVideoPlayer(methodName: "seeking"): boolean;
	igVideoPlayer(methodName: "destroy"): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "sources"): any[];
	igVideoPlayer(optionLiteral: 'option', optionName: "sources", optionValue: any[]): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "width"): number;
	igVideoPlayer(optionLiteral: 'option', optionName: "width", optionValue: number): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "height"): number;
	igVideoPlayer(optionLiteral: 'option', optionName: "height", optionValue: number): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "posterUrl"): string;
	igVideoPlayer(optionLiteral: 'option', optionName: "posterUrl", optionValue: string): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "preload"): boolean;
	igVideoPlayer(optionLiteral: 'option', optionName: "preload", optionValue: boolean): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "autoplay"): boolean;
	igVideoPlayer(optionLiteral: 'option', optionName: "autoplay", optionValue: boolean): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "autohide"): boolean;
	igVideoPlayer(optionLiteral: 'option', optionName: "autohide", optionValue: boolean): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "volumeAutohideDelay"): number;
	igVideoPlayer(optionLiteral: 'option', optionName: "volumeAutohideDelay", optionValue: number): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "centerButtonHideDelay"): number;
	igVideoPlayer(optionLiteral: 'option', optionName: "centerButtonHideDelay", optionValue: number): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "loop"): boolean;
	igVideoPlayer(optionLiteral: 'option', optionName: "loop", optionValue: boolean): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "browserControls"): boolean;
	igVideoPlayer(optionLiteral: 'option', optionName: "browserControls", optionValue: boolean): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "fullscreen"): boolean;
	igVideoPlayer(optionLiteral: 'option', optionName: "fullscreen", optionValue: boolean): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "volume"): number;
	igVideoPlayer(optionLiteral: 'option', optionName: "volume", optionValue: number): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "muted"): boolean;
	igVideoPlayer(optionLiteral: 'option', optionName: "muted", optionValue: boolean): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "title"): string;
	igVideoPlayer(optionLiteral: 'option', optionName: "title", optionValue: string): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "showSeekTime"): boolean;
	igVideoPlayer(optionLiteral: 'option', optionName: "showSeekTime", optionValue: boolean): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "progressLabelFormat"): string;
	igVideoPlayer(optionLiteral: 'option', optionName: "progressLabelFormat", optionValue: string): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "bookmarks"): IgVideoPlayerBookmark[];
	igVideoPlayer(optionLiteral: 'option', optionName: "bookmarks", optionValue: IgVideoPlayerBookmark[]): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "relatedVideos"): IgVideoPlayerRelatedVideo[];
	igVideoPlayer(optionLiteral: 'option', optionName: "relatedVideos", optionValue: IgVideoPlayerRelatedVideo[]): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "banners"): IgVideoPlayerBanner[];
	igVideoPlayer(optionLiteral: 'option', optionName: "banners", optionValue: IgVideoPlayerBanner[]): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "commercials"): IgVideoPlayerCommercials;
	igVideoPlayer(optionLiteral: 'option', optionName: "commercials", optionValue: IgVideoPlayerCommercials): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "ended"): EndedEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "ended", optionValue: EndedEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "playing"): PlayingEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "playing", optionValue: PlayingEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "paused"): PausedEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "paused", optionValue: PausedEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "buffering"): BufferingEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "buffering", optionValue: BufferingEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "progress"): ProgressEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "progress", optionValue: ProgressEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "waiting"): WaitingEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "waiting", optionValue: WaitingEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "bookmarkHit"): BookmarkHitEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "bookmarkHit", optionValue: BookmarkHitEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "bookmarkClick"): BookmarkClickEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "bookmarkClick", optionValue: BookmarkClickEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "enterFullScreen"): EnterFullScreenEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "enterFullScreen", optionValue: EnterFullScreenEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "exitFullScreen"): ExitFullScreenEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "exitFullScreen", optionValue: ExitFullScreenEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "relatedVideoClick"): RelatedVideoClickEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "relatedVideoClick", optionValue: RelatedVideoClickEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "bannerVisible"): BannerVisibleEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "bannerVisible", optionValue: BannerVisibleEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "bannerHidden"): BannerHiddenEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "bannerHidden", optionValue: BannerHiddenEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "bannerClick"): BannerClickEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "bannerClick", optionValue: BannerClickEvent): void;
	igVideoPlayer(optionLiteral: 'option', optionName: "browserNotSupported"): BrowserNotSupportedEvent;
	igVideoPlayer(optionLiteral: 'option', optionName: "browserNotSupported", optionValue: BrowserNotSupportedEvent): void;
	igVideoPlayer(options: IgVideoPlayer): JQuery;
	igVideoPlayer(optionLiteral: 'option', optionName: string): any;
	igVideoPlayer(optionLiteral: 'option', options: IgVideoPlayer): JQuery;
	igVideoPlayer(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igVideoPlayer(methodName: string, ...methodParams: any[]): any;
}
interface IgZoombarDefaultZoomWindow {
	left?: number;
	width?: string;
}

interface ZoomChangingEvent {
	(event: Event, ui: ZoomChangingEventUIParam): void;
}

interface ZoomChangingEventUIParam {
	owner?: any;
}

interface ZoomChangedEvent {
	(event: Event, ui: ZoomChangedEventUIParam): void;
}

interface ZoomChangedEventUIParam {
	owner?: any;
}

interface WindowDragStartingEvent {
	(event: Event, ui: WindowDragStartingEventUIParam): void;
}

interface WindowDragStartingEventUIParam {
	owner?: any;
}

interface WindowDragStartedEvent {
	(event: Event, ui: WindowDragStartedEventUIParam): void;
}

interface WindowDragStartedEventUIParam {
	owner?: any;
}

interface WindowDraggingEvent {
	(event: Event, ui: WindowDraggingEventUIParam): void;
}

interface WindowDraggingEventUIParam {
	owner?: any;
}

interface WindowDragEndingEvent {
	(event: Event, ui: WindowDragEndingEventUIParam): void;
}

interface WindowDragEndingEventUIParam {
	owner?: any;
}

interface WindowDragEndedEvent {
	(event: Event, ui: WindowDragEndedEventUIParam): void;
}

interface WindowDragEndedEventUIParam {
	owner?: any;
}

interface WindowResizingEvent {
	(event: Event, ui: WindowResizingEventUIParam): void;
}

interface WindowResizingEventUIParam {
	owner?: any;
}

interface IgZoombar {
	type?: any;
	target?: any;
	clone?: any;
	width?: any;
	height?: any;
	zoomAction?: any;
	zoomWindowMoveDistance?: number;
	defaultZoomWindow?: IgZoombarDefaultZoomWindow;
	zoomWindowMinWidth?: number;
	hoverStyleAnimationDuration?: number;
	windowPanDuration?: number;
	tabIndex?: number;
	zoomChanging?: ZoomChangingEvent;
	zoomChanged?: ZoomChangedEvent;
	windowDragStarting?: WindowDragStartingEvent;
	windowDragStarted?: WindowDragStartedEvent;
	windowDragging?: WindowDraggingEvent;
	windowDragEnding?: WindowDragEndingEvent;
	windowDragEnded?: WindowDragEndedEvent;
	windowResizing?: WindowResizingEvent;
	windowResized?: WindowResizedEvent;
}
interface IgZoombarMethods {
	destroy(): void;
	widget(): void;
	id(): string;
	container(): Element;
	clone(): Element;
	zoom(left?: number, width?: number): Object;
}
interface JQuery {
	data(propertyName: "igZoombar"):IgZoombarMethods;
}

declare module Infragistics {
export class ZoombarProviderDefault  {
}
}

declare module Infragistics {
export class ZoombarProviderDataChart extends ZoombarProviderDefault {
}
}

interface JQuery {
	igZoombar(methodName: "destroy"): void;
	igZoombar(methodName: "widget"): void;
	igZoombar(methodName: "id"): string;
	igZoombar(methodName: "container"): Element;
	igZoombar(methodName: "clone"): Element;
	igZoombar(methodName: "zoom", left?: number, width?: number): Object;
	igZoombar(optionLiteral: 'option', optionName: "type"): any;
	igZoombar(optionLiteral: 'option', optionName: "type", optionValue: any): void;
	igZoombar(optionLiteral: 'option', optionName: "target"): any;
	igZoombar(optionLiteral: 'option', optionName: "target", optionValue: any): void;
	igZoombar(optionLiteral: 'option', optionName: "clone"): any;
	igZoombar(optionLiteral: 'option', optionName: "clone", optionValue: any): void;
	igZoombar(optionLiteral: 'option', optionName: "width"): any;
	igZoombar(optionLiteral: 'option', optionName: "width", optionValue: any): void;
	igZoombar(optionLiteral: 'option', optionName: "height"): any;
	igZoombar(optionLiteral: 'option', optionName: "height", optionValue: any): void;
	igZoombar(optionLiteral: 'option', optionName: "zoomAction"): any;
	igZoombar(optionLiteral: 'option', optionName: "zoomAction", optionValue: any): void;
	igZoombar(optionLiteral: 'option', optionName: "zoomWindowMoveDistance"): number;
	igZoombar(optionLiteral: 'option', optionName: "zoomWindowMoveDistance", optionValue: number): void;
	igZoombar(optionLiteral: 'option', optionName: "defaultZoomWindow"): IgZoombarDefaultZoomWindow;
	igZoombar(optionLiteral: 'option', optionName: "defaultZoomWindow", optionValue: IgZoombarDefaultZoomWindow): void;
	igZoombar(optionLiteral: 'option', optionName: "zoomWindowMinWidth"): number;
	igZoombar(optionLiteral: 'option', optionName: "zoomWindowMinWidth", optionValue: number): void;
	igZoombar(optionLiteral: 'option', optionName: "hoverStyleAnimationDuration"): number;
	igZoombar(optionLiteral: 'option', optionName: "hoverStyleAnimationDuration", optionValue: number): void;
	igZoombar(optionLiteral: 'option', optionName: "windowPanDuration"): number;
	igZoombar(optionLiteral: 'option', optionName: "windowPanDuration", optionValue: number): void;
	igZoombar(optionLiteral: 'option', optionName: "tabIndex"): number;
	igZoombar(optionLiteral: 'option', optionName: "tabIndex", optionValue: number): void;
	igZoombar(optionLiteral: 'option', optionName: "zoomChanging"): ZoomChangingEvent;
	igZoombar(optionLiteral: 'option', optionName: "zoomChanging", optionValue: ZoomChangingEvent): void;
	igZoombar(optionLiteral: 'option', optionName: "zoomChanged"): ZoomChangedEvent;
	igZoombar(optionLiteral: 'option', optionName: "zoomChanged", optionValue: ZoomChangedEvent): void;
	igZoombar(optionLiteral: 'option', optionName: "windowDragStarting"): WindowDragStartingEvent;
	igZoombar(optionLiteral: 'option', optionName: "windowDragStarting", optionValue: WindowDragStartingEvent): void;
	igZoombar(optionLiteral: 'option', optionName: "windowDragStarted"): WindowDragStartedEvent;
	igZoombar(optionLiteral: 'option', optionName: "windowDragStarted", optionValue: WindowDragStartedEvent): void;
	igZoombar(optionLiteral: 'option', optionName: "windowDragging"): WindowDraggingEvent;
	igZoombar(optionLiteral: 'option', optionName: "windowDragging", optionValue: WindowDraggingEvent): void;
	igZoombar(optionLiteral: 'option', optionName: "windowDragEnding"): WindowDragEndingEvent;
	igZoombar(optionLiteral: 'option', optionName: "windowDragEnding", optionValue: WindowDragEndingEvent): void;
	igZoombar(optionLiteral: 'option', optionName: "windowDragEnded"): WindowDragEndedEvent;
	igZoombar(optionLiteral: 'option', optionName: "windowDragEnded", optionValue: WindowDragEndedEvent): void;
	igZoombar(optionLiteral: 'option', optionName: "windowResizing"): WindowResizingEvent;
	igZoombar(optionLiteral: 'option', optionName: "windowResizing", optionValue: WindowResizingEvent): void;
	igZoombar(optionLiteral: 'option', optionName: "windowResized"): WindowResizedEvent;
	igZoombar(optionLiteral: 'option', optionName: "windowResized", optionValue: WindowResizedEvent): void;
	igZoombar(options: IgZoombar): JQuery;
	igZoombar(optionLiteral: 'option', optionName: string): any;
	igZoombar(optionLiteral: 'option', options: IgZoombar): JQuery;
	igZoombar(optionLiteral: 'option', optionName: string, optionValue: any): JQuery;
	igZoombar(methodName: string, ...methodParams: any[]): any;
}

interface IgLoader {
    scriptPath: string;
    cssPath: string;
    resources?: string;
    theme?: string;
    ready?: Function;
    localePath?: string;
    locale?: string;
    autoDetectLocale?: boolean;
    regional?: string;
    preinit?: Function;
}

interface IgniteUIStatic {
    tmpl(template: string, data: any, ...args: any[]): string;
    loader(options: IgLoader): void;
    loader(callback: Function): void;
    loader(resources: string, callback: Function): void;
    loader(): any;
    OlapUtilities: any;
}

interface JQueryStatic {
    ig: IgniteUIStatic;
}
